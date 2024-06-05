document.addEventListener("DOMContentLoaded", function() {
  var videos = [
    "/video/001.mp4",
    "/video/002.mp4",
    "/video/003.mp4",
    "/video/004.mp4",
    "/video/005.mp4"
  ];

  // 페이지 로드 시 무작위 비디오 선택
  var randomIndex = Math.floor(Math.random() * videos.length);
  var randomVideo = videos[randomIndex];

  var videoElement = document.querySelector(".popular_movie video");
  videoElement.setAttribute("src", randomVideo);

  var currentVideoIndex = randomIndex;

  // 영상이 끝나면 다음 영상을 재생하는 함수
  function playNextVideo() {
    currentVideoIndex++; // 다음 영상의 인덱스로 이동
    if (currentVideoIndex >= videos.length) {
      currentVideoIndex = 0; // 다음 영상이 없으면 처음 영상으로 돌아감
    }
    videoElement.src = videos[currentVideoIndex]; // 다음 영상의 경로를 설정
    videoElement.play(); // 다음 영상 재생
  }

  // 영상이 끝나면 다음 영상을 재생하는 이벤트 핸들러 등록
  videoElement.addEventListener("ended", playNextVideo);

  // 스크롤 이벤트를 감지하여 애니메이션 적용
  var elements = document.querySelectorAll('.fade-in, .slide-in-left, .slide-in-right');
  window.addEventListener('scroll', function() {
    elements.forEach(function(element) {
      if (isElementInViewport(element)) {
        element.classList.add('visible');
      }
    });
  });

  function isElementInViewport(el) {
    var rect = el.getBoundingClientRect();
    return (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
  }

  // 페이지 로드 시 로그인 상태 확인
  checkLogin();
});

function checkLogin() {
  const isLoggedIn = localStorage.getItem('isLoggedIn');
  if (isLoggedIn === 'true') {
    document.getElementById('login-btn').style.display = 'none';
    document.getElementById('signup-btn').style.display = 'none';
    document.getElementById('logout-btn').style.display = 'block';
    document.getElementById('reservation-btn').style.display = 'block'; // 로그인 상태에서 예약 정보 버튼 표시
  } else {
    document.getElementById('login-btn').style.display = 'block';
    document.getElementById('signup-btn').style.display = 'block';
    document.getElementById('logout-btn').style.display = 'none';
    document.getElementById('reservation-btn').style.display = 'none'; // 로그인 상태가 아닐 때 예약 정보 버튼 숨김
  }
}

document.getElementById('logout').addEventListener('click', function() {
  localStorage.setItem('isLoggedIn', 'false');
  alert('로그아웃 되었습니다.');
  window.location.href = '/html/jinjalogin.html';
});

// 예약 페이지로 이동 시 로그인 확인
document.querySelectorAll('a.reservation-link').forEach(link => {
  link.addEventListener('click', function(event) {
    if (localStorage.getItem('isLoggedIn') !== 'true') {
      event.preventDefault();
      window.location.href = '/html/jinjalogin.html';
    }
  });
});
