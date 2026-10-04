pragma Singleton
import qs
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/*
 * Watches the upstream end4-pC repository for new commits and pings the user.
 * Compares the local shell folder's git HEAD against the upstream URL with
 * `git ls-remote` (no GitHub API, no rate limits). Set
 * Config.options.updates.notifyUpstreamUpdates = false to disable.
 */
Singleton {
    id: root

    property bool hasUpdates: false
    property string localSha: ""
    property string remoteSha: ""
    readonly property string upstreamUrl: "https://github.com/pctrade/end4-pC.git"
    readonly property string shellDir: Quickshell.shellPath("")

    function check() {
        if (!Config.ready || !Config.options.updates.notifyUpstreamUpdates) return;
        // Reset previous results so a failed network attempt can't compare stale SHAs
        root.remoteSha = "";
        root.localSha = "";
        localProc.running = true;
    }

    function apply(updated) {
        if (updated && !root.hasUpdates) {
            Quickshell.execDetached(["notify-send",
                "end4-pC",
                Translation.tr("New upstream version available — check Settings → About"),
                "-a", "Shell", "-u", "normal"
            ])
        }
        root.hasUpdates = updated;
    }

    function evaluate() {
        if (localSha === "" || remoteSha === "") return;
        if (remoteSha === localSha) {
            root.apply(false);
            return;
        }
        // SHAs differ — for forks this is the norm (local is ahead), so only
        // ping when the upstream commit is NOT already contained in local HEAD
        ancestryProc.running = true;
    }

    onLocalShaChanged: evaluate()
    onRemoteShaChanged: evaluate()

    // First check shortly after startup, then periodically
    Timer {
        interval: 3 * 60 * 1000
        running: Config.ready && Config.options.updates.notifyUpstreamUpdates
        repeat: false
        onTriggered: root.check()
    }

    Timer {
        interval: Math.max(30, Config.options.updates.upstreamCheckInterval) * 60 * 1000
        running: Config.ready && Config.options.updates.notifyUpstreamUpdates
        repeat: true
        onTriggered: root.check()
    }

    Process {
        id: localProc
        command: ["git", "-C", root.shellDir, "rev-parse", "HEAD"]
        stdout: SplitParser {
            onRead: data => {
                root.localSha = data.trim();
                remoteProc.running = true;
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) root.localSha = ""; // not a git checkout; skip silently
        }
    }

    Process {
        id: remoteProc
        command: ["bash", "-c", "git ls-remote " + root.upstreamUrl + " HEAD | cut -f1"]
        stdout: SplitParser {
            onRead: data => {
                root.remoteSha = data.trim();
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) root.remoteSha = ""; // offline or unreachable; skip silently
        }
    }

    Process {
        id: ancestryProc
        command: ["bash", "-c", "git -C '" + root.shellDir + "' merge-base --is-ancestor " + root.remoteSha + " HEAD >/dev/null 2>&1 && echo contained || echo not-contained"]
        stdout: SplitParser {
            onRead: data => {
                if (root.localSha === "" || root.remoteSha === "") return; // stale result from a previous check
                root.apply(data.trim() === "not-contained");
            }
        }
    }
}
