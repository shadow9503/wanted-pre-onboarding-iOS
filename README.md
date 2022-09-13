# weather_caster
---

## 개요

- 현재 날씨정보를 알려주는 APP
- 날씨 리스트와, 상세화면으로 구성


## 실행 모습

<p>
    <img width="200" height="600" src="[http://www.fillmurray.com/460/300](https://user-images.githubusercontent.com/33388081/189927287-49a3291c-a120-4aba-9045-f19af885451b.png)">
    <img width="200" height="600" src="[http://www.fillmurray.com/460/300](https://user-images.githubusercontent.com/33388081/189927350-d2d4482a-eece-45fb-acff-ab39af7ba998.png)">
</p>

https://user-images.githubusercontent.com/33388081/189927322-152ecf59-353e-4e7a-ab68-0cd8dc5231a7.png
https://user-images.githubusercontent.com/33388081/189927369-a1932ad1-34bf-489e-81da-34177d519b30.png


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
