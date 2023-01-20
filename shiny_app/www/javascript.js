// Javascript code supporting R shiny app //
// -------------------------------------- //

$( document ).ready( () => {

  // Making sure navbar doesn't overlap content
  // Add padding at the top of the page which is 12px bigger
  // than the navbar height
  var navHeight = $(".navbar").height();
  $("body").css({paddingTop: (navHeight+12)+'px'});

  // Do this again when the window is resized
  $(window).resize( () => {
    var navHeight = $(".navbar").height();
    $("body").css({paddingTop: (navHeight+12)+'px'});
  });


  // Ensures that when a modal opens keyboard focus is given to the
  // close button in the modal - accessibility
  $(document).on('shown.bs.modal', (x) => {
    // Hide popovers when a modal comes up so they don't overlap
    $(".popover").popover("hide");
    // With no more specific selector focus is given
    // to the last button on the page which is the modal button
    $('.modal-footer > .btn').focus();

  });

  $(document).on('hide.bs.modal', (x) => {
    $('.modal-footer > .btn').focus();
  });


  // For question mark box popovers on Summary page
  // When a new popover appears, hide all other popovers
  $(document).on('shown.bs.popover', (x) => {
    $(".popover:not(:last)").popover("hide");
  });

  // Fixes bug with bootstrap where you need to double click
  // to re-see a popover you've previously closed
  $(document).on('hidden.bs.popover', (x) => {
  // Conditional panels on introduction page also trigger hidden.bs.popover when they close
  // If we set inState.click = false for these then they stop rendering properly
  // To make sure we only deal with the summary page buttons, first check that the class
  // of the target which calls the event includes 'summary-btn'. Also need additional check
  // that target class is not undefined which allows us to ignore cases where the intro
  // page conditional panels trigger the event
    if($(x.target).attr("class") !== undefined){
      if($(x.target).attr("class").includes("summary-btn")){
        $(x.target).data("bs.popover").inState = { click: false, hover: false, focus: false };
      }
    }
  });


  // Hiding popovers when you change the tab
  $(document).on('hide.bs.tab', (x) => {
     $(".popover").popover("hide");
  });

  // When going to new tab
  $(document).on('shown.bs.tab', (x) => {
    // Hide all popovers
     $(".popover").popover("hide");
     // Fix plotly bug where if you change tabs before a plot has loaded the
     // plot ends up squashed. Do this by resizing all plotly plots when going
     // to a new tab
     // Need two .tab-pane.active because of top navbar and inner tabs
     var active_plots = $(".tab-pane.active .tab-pane.active .js-plotly-plot");
     for (var i = 0; i < active_plots.length; i++) {
        Plotly.relayout(active_plots[i].id, {autosize: true});
     }

  });


});
