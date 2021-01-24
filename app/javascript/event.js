document.addEventListener("DOMContentLoaded", () => {
const toggle = document.querySelector('.header__menu__toggle')
const side_bar = document.querySelector('.side-bar-menu')
const child = document.querySelector('.side-bar-menu__children')
const jun = document.querySelector('.side-bar-menu__bottom__juntube')
const oauth = document.querySelector('.side-bar-menu__bottom__oauth')
const dev = document.querySelector('.side-bar-menu__bottom__dev')

  toggle.addEventListener('click', function(){
    side_bar.classList.toggle('open')
    child.classList.toggle('open')
    jun.classList.toggle('open')
    oauth.classList.toggle('open')
    dev.classList.toggle('open')
  });
});