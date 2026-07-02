(function () {
  'use strict';

  function track(event, params) {
    if (typeof gtag !== 'function') return;
    gtag('event', event, params || {});
  }

  // ── Scroll depth ───────────────────────────────────────────────
  var scrollMilestones = [25, 50, 75, 90];
  var scrollFired = {};

  function onScroll() {
    var scrolled = window.scrollY + window.innerHeight;
    var total = document.documentElement.scrollHeight;
    var pct = Math.round((scrolled / total) * 100);
    scrollMilestones.forEach(function (m) {
      if (!scrollFired[m] && pct >= m) {
        scrollFired[m] = true;
        track('scroll_depth', { percent_scrolled: m });
      }
    });
  }

  window.addEventListener('scroll', onScroll, { passive: true });

  // ── Section visibility ─────────────────────────────────────────
  if ('IntersectionObserver' in window) {
    var sectionObserver = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          var id = entry.target.id || entry.target.className.split(' ')[0];
          track('section_view', { section_id: id });
          sectionObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.3 });

    document.querySelectorAll('section').forEach(function (s) {
      sectionObserver.observe(s);
    });
  }

  // ── CTA clicks ─────────────────────────────────────────────────
  document.querySelectorAll('.btn-primary, a[href="#hotline"]').forEach(function (el) {
    el.addEventListener('click', function () {
      track('cta_click', {
        cta_id: el.getAttribute('href') || el.className,
        cta_text: el.textContent.trim().slice(0, 80)
      });
    });
  });

  // ── Resume download ────────────────────────────────────────────
  document.querySelectorAll('a[href*="resume"]').forEach(function (el) {
    el.addEventListener('click', function () {
      track('file_download', {
        file_name: 'Alex_Girard_resume.pdf',
        link_text: el.textContent.trim().slice(0, 80)
      });
    });
  });

  // ── Outbound + social clicks ───────────────────────────────────
  var socialDomains = { 'github.com': 'github', 'linkedin.com': 'linkedin' };

  document.querySelectorAll('a[href]').forEach(function (el) {
    var href = el.getAttribute('href') || '';
    var isExternal = /^https?:\/\//.test(href) && href.indexOf(window.location.hostname) === -1;
    if (!isExternal) return;

    var platform = null;
    Object.keys(socialDomains).forEach(function (domain) {
      if (href.indexOf(domain) !== -1) platform = socialDomains[domain];
    });

    el.addEventListener('click', function () {
      if (platform) {
        track('social_click', {
          platform: platform,
          link_url: href,
          link_text: el.textContent.trim().slice(0, 80)
        });
      } else {
        track('outbound_click', {
          link_url: href,
          link_text: el.textContent.trim().slice(0, 80)
        });
      }
    });
  });

  // ── Project card clicks ────────────────────────────────────────
  document.querySelectorAll('.project-card__link').forEach(function (el) {
    el.addEventListener('click', function () {
      var card = el.closest('.project-card');
      var name = card ? (card.querySelector('.project-card__name') || {}).textContent : '';
      track('project_click', {
        project_name: (name || '').trim(),
        link_url: el.getAttribute('href')
      });
    });
  });

  // ── Navigation clicks ──────────────────────────────────────────
  document.querySelectorAll('.site-nav__link, .site-nav__mobile-link, .site-nav__mobile-hotline').forEach(function (el) {
    el.addEventListener('click', function () {
      track('nav_click', {
        nav_label: el.textContent.trim().slice(0, 40),
        nav_href: el.getAttribute('href')
      });
    });
  });

  // ── Mobile menu toggle ─────────────────────────────────────────
  var menuBtn = document.getElementById('mobile-menu-button');
  if (menuBtn) {
    menuBtn.addEventListener('click', function () {
      var isOpen = menuBtn.getAttribute('aria-expanded') === 'true';
      track('mobile_menu_toggle', { action: isOpen ? 'open' : 'close' });
    });
  }

  // ── Hotline form lifecycle ─────────────────────────────────────
  var hotlineForm = document.getElementById('hotline-form');
  if (hotlineForm) {
    var formStarted = false;

    hotlineForm.querySelectorAll('input, textarea').forEach(function (field) {
      field.addEventListener('focus', function () {
        if (!formStarted) {
          formStarted = true;
          track('form_start', { form_id: 'hotline' });
        }
      }, { once: false });
    });

    hotlineForm.addEventListener('submit', function () {
      track('form_submit', { form_id: 'hotline' });
    });

    var successEl = document.querySelector('[data-fs-success]');
    if (successEl && 'MutationObserver' in window) {
      var successObserver = new MutationObserver(function () {
        var visible = successEl.style.display !== 'none' &&
                      !successEl.hidden &&
                      successEl.offsetParent !== null;
        if (visible) {
          track('form_success', { form_id: 'hotline' });
          successObserver.disconnect();
        }
      });
      successObserver.observe(successEl, { attributes: true, childList: true, subtree: true });
    }
  }

  // ── Time on page milestones ────────────────────────────────────
  var timeMilestones = [30, 60, 120, 300];
  var timeIdx = 0;

  function scheduleNext() {
    if (timeIdx >= timeMilestones.length) return;
    var delay = (timeMilestones[timeIdx] - (timeIdx > 0 ? timeMilestones[timeIdx - 1] : 0)) * 1000;
    setTimeout(function () {
      if (!document.hidden) {
        track('time_on_page', { seconds: timeMilestones[timeIdx] });
      }
      timeIdx++;
      scheduleNext();
    }, delay);
  }

  scheduleNext();

})();
