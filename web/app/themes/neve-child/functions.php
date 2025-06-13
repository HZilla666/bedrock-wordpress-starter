
<?php
add_action('wp_enqueue_scripts', function () {
  wp_enqueue_style('neve-child-style', get_stylesheet_uri());
}, 20);
