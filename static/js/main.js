document.addEventListener('DOMContentLoaded', function () {

  // ── Mobile nav toggle ──────────────────────────────────────────
  var btn  = document.getElementById('mobile-menu-button');
  var menu = document.getElementById('mobile-menu');

  if (btn && menu) {
    btn.addEventListener('click', function () {
      var open = menu.classList.toggle('open');
      btn.setAttribute('aria-expanded', open ? 'true' : 'false');
    });

    menu.querySelectorAll('.site-nav__mobile-link, .site-nav__mobile-hotline')
      .forEach(function (link) {
        link.addEventListener('click', function () {
          menu.classList.remove('open');
          btn.setAttribute('aria-expanded', 'false');
        });
      });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && menu.classList.contains('open')) {
        menu.classList.remove('open');
        btn.setAttribute('aria-expanded', 'false');
        btn.focus();
      }
    });
  }

});
