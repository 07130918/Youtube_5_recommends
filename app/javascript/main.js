document.addEventListener("DOMContentLoaded", () => {
  new Swiper(".swiper-container", {
    slidesPerView: 1,
    spaceBetween: 30,
    loop: false,
    effect: "coverflow",

    pagination: {
      el: ".swiper-pagination",
      clickable: true,
    },
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
  });
});
