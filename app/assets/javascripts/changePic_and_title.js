document.addEventListener('DOMContentLoaded', function() {
    const img = ["/assets/NC_066956.png", "/assets/NC_030369.png", "/assets/CP071572.png"];
    const titles = ["タイトル1", "タイトル2", "タイトル3"];
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
      setTimeout(picChange, 4000);
    }
  });