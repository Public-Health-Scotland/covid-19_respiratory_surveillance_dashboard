// Javascript code supporting R shiny app
// Ensures that when a modal opens keyboard focus is given to the
// close button in the modal - accessibility
$(document).on('shown.bs.modal', (x) => {
  // Hide popovers when a modal comes up so they don't overlap
  $(".popover").popover("hide");
  // With no more specific selector focus is given
  // to the last button on the page which is the modal button
  $('button').focus();

});

$(document).on('hide.bs.modal', (x) => {
  $('button').focus();
});


// For question mark box popovers on Summary page
// When a new popover appears, hide all other popovers
$(document).on('shown.bs.popover', (x) => {
  $(".popover:not(:last)").popover("hide");
});

// Fixes bug with bootstrap where you need to double click
// to re-see a popover you've previously closed
$(document).on('hidden.bs.popover', function (e) {
    $(e.target).data("bs.popover").inState.click = false;
});