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

  // ── Latest Mastodon posts ───────────────────────────────────
  var latestList = document.getElementById('latest-list');

  if (latestList) {
    var feedUrl = 'https://mastodon.tetaneutral.net/@alx.rss';

    fetch(feedUrl)
      .then(function (res) {
        if (!res.ok) throw new Error('feed request failed');
        return res.text();
      })
      .then(function (xml) {
        var doc = new DOMParser().parseFromString(xml, 'text/xml');
        var items = Array.prototype.slice.call(doc.querySelectorAll('item'));
        latestList.innerHTML = '';
        items.slice(0, 5).forEach(function (item) {
          var titleEl = item.querySelector('title');
          var descEl = item.querySelector('description');
          var linkEl = item.querySelector('link');
          var pubEl = item.querySelector('pubDate');

          function textFrom(el) {
            return el ? el.textContent.trim() : '';
          }

          // Mastodon items have no <title>; fall back to the HTML description.
          var title = textFrom(titleEl);
          if (!title && descEl) {
            var div = document.createElement('div');
            div.innerHTML = descEl.textContent;
            title = (div.textContent || '').replace(/\s+/g, ' ').trim();
            if (title.length > 140) {
              title = title.slice(0, 140).replace(/\s+\S*$/, '') + '…';
            }
          }

          var li = document.createElement('li');
          li.className = 'latest__item';

          var a = document.createElement('a');
          a.className = 'latest__link';
          a.href = textFrom(linkEl) || '#';
          a.target = '_blank';
          a.rel = 'noopener noreferrer';

          // Mastodon prepends 🔖 to bookmarks; render as an accent bullet instead.
          if (title.indexOf('🔖') === 0) {
            title = title.slice('🔖'.length).trim();
            var bullet = document.createElement('span');
            bullet.className = 'latest__bullet';
            bullet.setAttribute('aria-hidden', 'true');
            a.appendChild(bullet);
          }
          a.appendChild(document.createTextNode(title || '(untitled)'));
          li.appendChild(a);

          if (pubEl && pubEl.textContent) {
            var date = new Date(pubEl.textContent);
            if (!isNaN(date.getTime())) {
              var t = document.createElement('span');
              t.className = 'latest__date';
              t.textContent = date.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });
              li.appendChild(t);
            }
          }

          latestList.appendChild(li);
        });
      })
      .catch(function () {
        if (latestList) {
          latestList.innerHTML = '<li class="latest__error">Could not load latest posts.</li>';
        }
      });
  }

});
