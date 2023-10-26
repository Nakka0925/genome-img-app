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
//= require activestorage
//= require_tree .
//= require jquery

// アコーディオンメニュー
  $(function(){
    $('.js-accordion-title').on('click', function () {
      /*クリックでコンテンツを開閉*/
      $(this).next().slideToggle(200);
      /*矢印の向きを変更*/
      $(this).toggleClass('open', 200);
    });
  });
  document.addEventListener('DOMContentLoaded', function() {
    const img = ["NC_025221.png", "KX686108.png", "CP071572.png"];
    const titles = ["シシオザル", "ウシガエル", "イノシシ"];
    let count = -1;
    const changePic = document.getElementById('changePic'); // HTML要素を取得
    const changeTitle = document.getElementById('changeTitle');
    picChange();

    function picChange() {
      count++;
      if (count == img.length) count = 0;
      // 画像選択
      changePic.src = img[count];
      changeTitle.textContent = titles[count];
      // 秒数の指定
      setTimeout(picChange, 3000);
    }
  });