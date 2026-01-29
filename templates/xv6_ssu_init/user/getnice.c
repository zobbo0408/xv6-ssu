#include "types.h"
#include "stat.h"
#include "user.h" // getnice() 시스템 콜 선언 포함

int
main(int argc, char *argv[])
{
  int pid, priority;

  // 1. 인자 개수 확인 (명령어 이름, PID 총 2개여야 함)
  if(argc < 2){
    printf(1, "Usage: getnice pid\n");
    exit();
  }

  // 2. 문자열 인자를 정수로 변환
  pid = atoi(argv[1]);

  // 3. 실제 시스템 콜 호출
  priority = getnice(pid);

  // 4. 결과 출력
  if(priority < 0){
    printf(2, "getnice: process with pid %d not found\n", pid);
  } else {
    printf(1, "Process %d priority is %d\n", pid, priority);
  }

  exit();
}
