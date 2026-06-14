// Phase 8: product-management page behaviour moved out of ProductManagement.aspx
(function () {
    function onReady(callback) {
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", callback);
        } else {
            callback();
        }
    }

    onReady(function () {
        var config = window.troikaProductManagementConfig || {};
        var uploadInput = document.getElementById(config.uploadInputId || "fuEditPicture");
        var previewImg = document.getElementById(config.previewImageId || "imgEditCurrent");
        var productIdInput = document.getElementById(config.productIdInputId || "txtProductID");

        if (productIdInput) {
            productIdInput.addEventListener("focus", function () {
                productIdInput.blur();
            });
        }

        if (uploadInput && previewImg) {
            uploadInput.addEventListener("change", function () {
                if (uploadInput.files && uploadInput.files[0]) {
                    var reader = new FileReader();

                    reader.onloadstart = function () {
                        previewImg.classList.add("loading");
                    };

                    reader.onload = function (e) {
                        previewImg.src = e.target.result;
                        previewImg.classList.remove("loading");
                    };

                    reader.readAsDataURL(uploadInput.files[0]);
                }
            });
        }
    });
})();
