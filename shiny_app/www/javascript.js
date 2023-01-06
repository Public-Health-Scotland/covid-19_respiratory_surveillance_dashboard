// Javascript code supporting R shiny app

// Ensures that when a modal opens keyboard focus is given to the
// close button in the modal - accessibility
$(document).on('shown.bs.modal', (x) => {
                  // With no more specific selector focus is given
                  // to the last button on the page which is the modal button
                 $('button').focus();

              }
               );
