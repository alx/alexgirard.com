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

  // ── Hotline form state machine ─────────────────────────────────
  var form          = document.getElementById('hotline-form');
  var successPanel  = document.getElementById('hotline-success');
  if (!form || !successPanel) return;

  var nameInput     = document.getElementById('hotline-name');
  var emailInput    = document.getElementById('hotline-email');
  var questionInput = document.getElementById('hotline-question');
  var errorEl       = document.getElementById('hotline-error');
  var sendLink      = document.getElementById('hotline-send');
  var resetBtn      = document.getElementById('hotline-reset');

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    var name     = nameInput.value.trim();
    var email    = emailInput.value.trim();
    var question = questionInput.value.trim();

    if (!name || !email || !question) {
      errorEl.textContent = "A name, an email, and your question — that's all I need.";
      errorEl.classList.add('visible');
      return;
    }
    errorEl.classList.remove('visible');

    var to      = 'alex@girard-davila.net';
    var subject = encodeURIComponent('Hotline — 15 min: ' + name);
    var body    = encodeURIComponent(
      'From: ' + name + ' <' + email + '>\n\n' +
      'My question:\n' + question + '\n\n' +
      '— Sent from the hotline'
    );
    sendLink.href = 'mailto:' + to + '?subject=' + subject + '&body=' + body;

    form.style.display = 'none';
    successPanel.classList.add('visible');
  });

  resetBtn.addEventListener('click', function () {
    nameInput.value     = '';
    emailInput.value    = '';
    questionInput.value = '';
    errorEl.classList.remove('visible');
    successPanel.classList.remove('visible');
    form.style.display = '';
  });

});
