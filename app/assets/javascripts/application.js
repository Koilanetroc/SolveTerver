// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets

$(document).ready(function() {
    $("#test_data").click(function(){
        $("#x_area").html("9, 15, 10, 10, 12, 14, 7, 14, 14, 13, 17, 6, 13, 10, 10, 13, 13, 13, 14, 14, 12, 12, 8, 13, 14, 10, 14, 14, 12, 15, 13, 15, 14, 9, 12, 8, 11, 11, 12, 12, 12, 8, 8, 12, 11, 10, 14, 10, 12, 12, 13, 13, 13, 12, 15, 10, 12, 15, 10, 13, 12, 13, 16, 12, 16, 10, 12, 13, 8, 11, 13, 9, 11, 12, 9, 14, 13, 13, 13, 13, 7, 9, 13, 12, 14, 13, 11, 7, 12, 11, 13, 16, 10, 11, 12, 15, 11, 10, 11, 12")
        $("#y_area").html("30, 27, 23, 29, 27, 26, 33, 25, 25, 18, 25, 38, 26, 29, 31, 20, 27, 21, 21, 23, 31, 17, 38, 27, 20, 33, 25, 28, 31, 13, 16, 13, 18, 25, 21, 33, 38, 31, 32, 25, 31, 31, 30, 23, 26, 31, 25, 31, 22, 25, 22, 17, 23, 27, 16, 26, 26, 16, 34, 20, 32, 14, 17, 19, 16, 27, 24, 20, 39, 35, 22, 27, 24, 28, 38, 22, 27, 32, 21, 20, 31, 32, 25, 23, 21, 17, 21, 38, 26, 18, 27, 11, 29, 29, 25, 27, 27, 32, 20, 25")
    });
});
