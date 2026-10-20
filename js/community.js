/* ============================================================
   VerdeVivo - Community: posts, likes, comments, moderation
   ============================================================ */

window.Community = (() => {

  const ME_ID = 'me';

  function getPosts() { return App.getPosts(); }

  function postHtml(post) {
    const isMine = post.userId === ME_ID;
    const commentCount = post.comments ? post.comments.length : 0;
    return `
      <article class="card post-card">
        <div class="post-head">
          <img src="${post.avatar || App.avatarFor(post.author)}" alt="avatar de ${post.author}">
          <div>
            <div class="ph-name">${post.author}</div>
            <div class="ph-date">${formatPostDate(post.date)}</div>
          </div>
          <div class="ph-actions">
            ${isMine ? `
              <button class="icon-btn" data-edit-post="${post.id}" style="background:var(--green-lighter);color:var(--green-medium);width:36px;height:36px"><svg data-lucide="pencil" width="17" height="17"></svg></button>
              <button class="icon-btn" data-del-post="${post.id}" style="background:var(--coral-light);color:var(--coral-ink);width:36px;height:36px"><svg data-lucide="trash-2" width="17" height="17"></svg></button>`
            : `<button class="icon-btn" data-report-post="${post.id}" title="Denunciar publicação" style="background:var(--green-lighter);color:var(--text-muted);width:36px;height:36px"><svg data-lucide="flag" width="17" height="17"></svg></button>`}
          </div>
        </div>
        ${post.image ? `<img class="post-img" src="${post.image}" alt="${post.title}">` : ''}
        <div class="post-body">
          <div class="p-title">${post.title}</div>
          ${post.desc ? `<div class="p-desc">${post.desc}</div>` : ''}
        </div>
        <div class="post-actions">
          <button class="post-action ${post.liked ? 'liked' : ''}" data-like-post="${post.id}">
            <svg data-lucide="heart" width="18" height="18" fill="${post.liked ? 'currentColor' : 'none'}"></svg>
            ${post.likes > 0 ? post.likes : 'Curtir'}
          </button>
          <button class="post-action" data-comment-toggle="${post.id}">
            <svg data-lucide="message-circle" width="18" height="18"></svg>${commentCount ? commentCount : 'Comentar'}
          </button>
          <button class="post-action" data-share-post="${post.id}">
            <svg data-lucide="share-2" width="18" height="18"></svg>Compartilhar
          </button>
        </div>
        <div class="comments ${post._showComments ? '' : 'hidden'}" data-comments="${post.id}">
          ${(post.comments || []).map(c => `
            <div class="comment">
              <img src="${App.avatarFor(c.author)}" alt="avatar">
              <div class="c-body"><div class="c-name">${c.author}</div><div class="c-text">${c.text}</div></div>
            </div>`).join('')}
          <form class="comment-form" data-comment-form="${post.id}">
            <img src="${App.avatarFor(App.getProfile().name)}" alt="avatar">
            <input type="text" placeholder="Escreva um comentário...">
            <button class="btn btn-green btn-sm" type="submit">Enviar</button>
          </form>
        </div>
      </article>`;
  }

  function formatPostDate(dateStr) {
    const d = new Date(dateStr + 'T12:00:00');
    if (isNaN(d.getTime())) return dateStr;
    return d.toLocaleDateString('pt-BR', { day: '2-digit', month: 'short', year: 'numeric' });
  }

  return { getPosts, postHtml, formatPostDate, ME_ID };
})();