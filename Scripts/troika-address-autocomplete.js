// troika-address-autocomplete.js
// --------------------------------------------------------------------------
// Google Places Autocomplete for the Troika delivery-address forms.
//
// Attaches to any input marked .js-troika-street and, when the user picks a
// suggestion, fills the matching .js-troika-suburb and .js-troika-postcode
// fields from the chosen place. Suggestions are restricted to South Africa.
//
// The address is stored in the existing Customer table columns, so values are
// mapped + capped to fit them:
//     streetAddress varchar(50)  <- street_number + route   (capped to 50)
//     suburb        varchar(50)  <- sublocality_level_1 / locality fallbacks
//     postCode      varchar(4)   <- postal_code             (4-digit SA codes)
//
// This is a progressive enhancement: if the Maps script fails to load (offline,
// key/referrer issue), the fields stay fully editable by hand.
// --------------------------------------------------------------------------
(function () {
    "use strict";

    var STREET_MAXLEN = 50; // matches Customer.streetAddress varchar(50)

    // Set a value so ASP.NET validators / view state pick up the change.
    function setValue(el, value) {
        if (!el) return;

        var proto = Object.getPrototypeOf(el);
        var descriptor = proto ? Object.getOwnPropertyDescriptor(proto, "value") : null;
        if (descriptor && descriptor.set) {
            descriptor.set.call(el, value);
        } else {
            el.value = value;
        }

        el.dispatchEvent(new Event("input", { bubbles: true }));
        el.dispatchEvent(new Event("change", { bubbles: true }));
    }

    // Flatten place.address_components into { type: long_name }.
    function buildComponentMap(place) {
        var map = {};
        var components = (place && place.address_components) || [];
        for (var i = 0; i < components.length; i++) {
            var component = components[i];
            for (var j = 0; j < component.types.length; j++) {
                map[component.types[j]] = component.long_name;
            }
        }
        return map;
    }

    function get(map, type) {
        return map[type] || "";
    }

    function fillFromPlace(place, streetEl, suburbEl, postEl) {
        var map = buildComponentMap(place);

        var streetNumber = get(map, "street_number");
        var route = get(map, "route");
        var street = ((streetNumber ? streetNumber + " " : "") + route).trim();
        if (street.length > STREET_MAXLEN) {
            street = street.substring(0, STREET_MAXLEN).trim();
        }

        // In South Africa the "suburb" maps best to sublocality_level_1; fall
        // back through the related component types when it is not returned.
        var suburb = get(map, "sublocality_level_1")
            || get(map, "sublocality")
            || get(map, "neighborhood")
            || get(map, "locality")
            || "";

        var postCode = get(map, "postal_code");

        if (street) setValue(streetEl, street);
        if (suburb) setValue(suburbEl, suburb);
        if (postCode) setValue(postEl, postCode);
    }

    function attach(streetEl) {
        // Guard against double-binding the same input (e.g. when init runs again after a
        // partial postback that did not actually re-render this field).
        if (streetEl.getAttribute("data-troika-ac") === "1") return;
        streetEl.setAttribute("data-troika-ac", "1");

        // Each page is a single Web Forms <form> with one address block, so
        // scope the partner fields to that form.
        var scope = (streetEl.closest && streetEl.closest("form")) || document;
        var suburbEl = scope.querySelector(".js-troika-suburb");
        var postEl = scope.querySelector(".js-troika-postcode");

        var autocomplete = new google.maps.places.Autocomplete(streetEl, {
            componentRestrictions: { country: "za" },
            fields: ["address_components"],
            types: ["address"]
        });

        autocomplete.addListener("place_changed", function () {
            fillFromPlace(autocomplete.getPlace(), streetEl, suburbEl, postEl);
        });

        // While the suggestion dropdown is open, Enter should choose a result,
        // not submit the Web Forms page.
        streetEl.addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                var dropdown = document.querySelector(".pac-container");
                if (dropdown && dropdown.offsetParent !== null) {
                    e.preventDefault();
                }
            }
        });
    }

    function init() {
        if (!(window.google && google.maps && google.maps.places)) {
            return; // Maps unavailable; manual entry still works.
        }

        var streetInputs = document.querySelectorAll(".js-troika-street");
        for (var i = 0; i < streetInputs.length; i++) {
            attach(streetInputs[i]);
        }
    }

    // The Maps loader invokes this via &callback=initTroikaAddressAutocomplete.
    window.initTroikaAddressAutocomplete = init;

    // Re-bind after ASP.NET AJAX partial postbacks: the cart's UpdatePanel re-renders the
    // address form (a fresh input element), so the autocomplete must be re-attached. The
    // data-attribute guard in attach() prevents binding an unchanged input twice.
    if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(init);
    }
})();
