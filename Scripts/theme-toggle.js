(function () {
    var storageKey = "troika-theme";

    function applyTheme(theme) {
        document.body.setAttribute("data-theme", theme);
        var btn = document.getElementById("btnThemeToggle");
        if (btn) {
            btn.textContent = theme === "dark" ? "☀ Light mode" : "🌙 Dark mode";
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
