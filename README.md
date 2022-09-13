# weather_caster
---

## 개요

- 현재 날씨정보를 알려주는 APP
- 날씨 리스트와, 상세화면으로 구성

## 실행 모습

![스플래시](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/17a5e497-8874-4071-8ff7-1892ec03587c/Untitled.png)

스플래시

![날씨 상세 (Pull to refresh)](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e917898d-0709-4038-9057-7be90e658cfe/Untitled.png)

날씨 상세 (Pull to refresh)

![날씨 리스트 (메인)](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/64a5923f-116e-483a-afa6-d5207d5e3225/Untitled.png)

날씨 리스트 (메인)

![날씨 상세](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/bffc87b1-a530-40ed-bef4-0a45d8608f15/Untitled.png)

날씨 상세

## 상세

- MVC 패턴을 사용하여 구현
- OpenWeather의 Current weather data api를 사용
    - 20개의 지역에서 현재날씨 데이터를 가져오기위해,
    **Concurrent Queue**를 사용하여 다중 스레드 작업 수행.
- image는 처음 1회 이후로는 캐시된 이미지를 이용한다.
- 메인 페이지의 날씨 리스트와 상세페이지는 pull to refresh 방식으로
업데이트 가능.

## 💡이슈

### 1. 날씨 api 호출로 데이터 적재시 데이터가 무작위 갯수로 쌓이던 이슈

### 원인 추측

- ConcurrentQueue를 이용하여 다중 스레드작업을 수행
내부에서 수행되는 array append 작업이 동시에 수행되어 제대로 저장되지 않은것으로 보임.

### 해결

- thread safe 하기 위해 customQueue를 생성 
.barrier 옵션을 이용해 동시작업 방지.

```swift
customQueue.async(flags: .barrier) {
    // append
}
```
