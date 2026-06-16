(function () {
    var storageKey = "troika-theme";

    function applyTheme(theme) {
        document.body.setAttribute("data-theme", theme);
        var btn = document.getElementById("btnThemeToggle");
        if (btn) {
            // The button holds two SVG icons (moon/sun) and two text labels (Dark/Light Mode),
            // all shown/hidden purely via CSS based on body[data-theme], so we only update the
            // accessible label/tooltip here. (Setting textContent would wipe the icons + labels.)
            var label = theme === "dark" ? "Switch to light mode" : "Switch to dark mode";
            btn.setAttribute("aria-label", label);
            btn.setAttribute("title", label);
        }
    }

    window.TroikaTheme = {
        initialise: function () {
            var saved = localStorage.getItem(storageKey) || "light";
            applyTheme(saved);
        },
        toggle: function () {
            var current = document.body.getAttribute("data-theme") || "light";
            var next = current === "dark" ? "light" : "dark";
            localStorage.setItem(storageKey, next);
            applyTheme(next);
        }
    };

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", window.TroikaTheme.initialise);
    } else {
        window.TroikaTheme.initialise();
    }
})();
