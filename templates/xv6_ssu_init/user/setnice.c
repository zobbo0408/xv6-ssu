#include "types.h"
#include "stat.h"
#include "user.h" // setnice() 시스템 콜 선언이 들어있는 곳

int
main(int argc, char *argv[])
{
  int pid, value;

  // 1. 인자 개수 확인 (명령어 이름 포함 총 3개여야 함: setnice, pid, value)
  if(argc < 3){
    printf(1, "Usage: setnice pid value\n");
    exit();
  }

  // 2. 문자열로 된 인자를 정수로 변환 (atoi 함수 사용)
  pid = atoi(argv[1]);
  value = atoi(argv[2]);

  // 3. 실제 시스템 콜 호출
  if(setnice(pid, value) < 0){
    printf(2, "setnice: failed to set priority\n");
  } else {
    printf(1, "setnice: pid %d priority set to %d\n", pid, value);
  }

  exit();
}
