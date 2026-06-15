// Animates the free-delivery progress bar from 0 up to its target width so the user
// sees it fill. The server renders each .dt-fill with width:0 and a data-target percent;
// this grows it to the target (the CSS transition on .dt-fill plays the motion).
(function () {
    function fillTrackers() {
        var fills = document.querySelectorAll(".dt-fill[data-target]");

        // Double rAF guarantees a layout at width:0 before the target is applied,
        // so the transition animates rather than snapping.
        requestAnimationFrame(function () {
            requestAnimationFrame(function () {
                for (var i = 0; i < fills.length; i++) {
                    var target = fills[i].getAttribute("data-target") || "0";
                    fills[i].style.width = target + "%";
                }
            });
        });
    }

    function onReady(callback) {
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", callback);
        } else {
            callback();
        }
    }

    onReady(fillTrackers);

    // Re-run after ASP.NET AJAX partial postbacks (e.g. the quick-view cart popup is
    // shown via an UpdatePanel, so its .dt-fill is injected after DOMContentLoaded).
    if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(fillTrackers);
    }
})();
