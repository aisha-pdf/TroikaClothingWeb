// wishlist.js
// Heart-icon toggle for the Products page. Posts to WishlistHandler.ashx (no full
// postback) so the pop animation can play, then flips the heart's filled state.
// If the visitor is not a logged-in customer, the handler replies {login:true} and
// we send them to the login page. If an administrator tries to wishlist, the handler
// replies {admin:true} and we show the shared notice modal instead.
(function () {
    "use strict";

    function config() {
        var el = document.getElementById("troikaWishCfg");
        if (!el) return null;
        return {
            toggleUrl: el.getAttribute("data-toggle-url"),
            loginUrl: el.getAttribute("data-login-url")
        };
    }

    function closeNotice() {
        var overlay = document.getElementById("troikaNoticeModal");
        if (overlay) overlay.classList.remove("is-open");
    }

    // Lightweight, dependency-free notice modal. Created once and reused. Exposed on
    // window so server-rendered startup scripts (e.g. admin add-to-cart) can call it too.
    window.troikaNotice = function (message, title) {
        var overlay = document.getElementById("troikaNoticeModal");
        if (!overlay) {
            overlay = document.createElement("div");
            overlay.id = "troikaNoticeModal";
            overlay.className = "troika-notice-overlay";
            overlay.innerHTML =
                '<div class="troika-notice-box" role="dialog" aria-modal="true" aria-labelledby="troikaNoticeTitle">' +
                    '<div class="troika-notice-title" id="troikaNoticeTitle"></div>' +
                    '<div class="troika-notice-msg"></div>' +
                    '<div class="troika-notice-actions">' +
                        '<button type="button" class="troika-notice-ok">OK</button>' +
                    '</div>' +
                '</div>';
            document.body.appendChild(overlay);

            overlay.addEventListener("click", function (e) {
                if (e.target === overlay) closeNotice();
            });
            overlay.querySelector(".troika-notice-ok").addEventListener("click", closeNotice);
            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape") closeNotice();
            });
        }

        overlay.querySelector(".troika-notice-title").textContent = title || "Notice";
        overlay.querySelector(".troika-notice-msg").textContent = message;
        overlay.classList.add("is-open");
    };

    window.troikaToggleWish = function (btn) {
        var cfg = config();
        if (!cfg || !btn) return;

        var productId = btn.getAttribute("data-productid");
        if (!productId || btn.classList.contains("is-busy")) return;

        btn.classList.add("is-busy");

        fetch(cfg.toggleUrl, {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            credentials: "same-origin",
            body: "productId=" + encodeURIComponent(productId)
        })
            .then(function (response) { return response.json(); })
            .then(function (data) {
                btn.classList.remove("is-busy");

                if (data.admin) {
                    window.troikaNotice(
                        "Administrators are not allowed to wishlist items. Please create or log in to a customer account.",
                        "Action not allowed");
                    return;
                }
                if (data.login) {
                    window.location = cfg.loginUrl;
                    return;
                }
                if (!data.ok) return;

                if (data.added) {
                    btn.classList.add("is-wished");
                    btn.setAttribute("aria-label", "Remove from wishlist");
                    // Restart the pop animation each time it is added.
                    btn.classList.remove("is-bursting");
                    void btn.offsetWidth;
                    btn.classList.add("is-bursting");
                } else {
                    btn.classList.remove("is-wished");
                    btn.classList.remove("is-bursting");
                    btn.setAttribute("aria-label", "Add to wishlist");
                }
            })
            .catch(function () {
                btn.classList.remove("is-busy");
            });
    };
})();
