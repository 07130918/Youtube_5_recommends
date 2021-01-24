document.addEventListener("turbolinks:load", () => {
  const toggle = document.querySelector('.header__menu__toggle')
  const side_bar = document.querySelector('.side-bar-menu')
  const child = document.querySelector('.side-bar-menu__children')
  const jun = document.querySelector('.side-bar-menu__bottom__juntube')
  const oauth = document.querySelector('.side-bar-menu__bottom__oauth')
  const dev = document.querySelector('.side-bar-menu__bottom__dev')
  
  function open(dom){
    dom.classList.toggle('open')
  }
  
  toggle.addEventListener('click', function(){
    open(side_bar);
    open(child);
    open(jun);
    open(oauth);
    open(dev);
  });
});