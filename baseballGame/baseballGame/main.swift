//
//  main.swift
//  NumBaseballGame
//
//  Created by 손겸 on 11/5/24.
//
//

/* 각 클래스별로 기능 나누기
 - 정답 클래스 만들기
 - Input 클래스 만들기
 - 힌트 클래스 만들기 ( 스트라이크와 볼 구분)
 - baseballGame 클래스 만들기 ( 전체적인 관리, 각 클래스의 메서드 호출)
 ---------------------------------------------------------
 - 에러코드 따로 처리 하기 도전 !!!
 
 */
import Foundation

// error
enum InputError: Error {
    case emptyInput // 공란 입력
    case notANumber // 숫자가 아닌 다른 것
    case numLimit   // 세 자릿수가 아닌 것
    case duplicated // 중복인 것
}

// 정답 class - 정답을 랜덤으로 생성
class AnswerGenerator {
    func generate() -> [Int] {
        var numbers = Set<Int>() // 중복 제거를 위한 set 사용
        while numbers.count < 3 {
            let number = Int.random(in: 1...9)
            numbers.insert(number)
        }
        return Array(numbers)
    }
}
// Intput class - 입력값을 받고 3자리가 맞는지 숫자인지 확인한다.
class InputHandler {
    func getInput() throws -> String {
        print("ㄴ ", terminator: "")
        
        // 공백으로 입력 할 경우
        if let input = readLine() {
            guard !input.isEmpty else {
                throw InputError.emptyInput
            }
            // 숫자가 아닌 경우 처리
            guard Int(input) != nil else {
                throw InputError.notANumber
            }
            // 세 자리 이외로 쓸 경우
            guard let number = Int(input), 100...999 ~= number else {
                throw InputError.numLimit
            }
            // 중복된 숫자가 있을 경우
            guard Set(input).count == 3 else {
                throw InputError.duplicated
            }
        
            return input
            
        } else {
            print("숫자를 입력하세요!")
            return "" // 빈 문자열이라도 리턴하여 오류를 던지지 않도록 처리
        }
    }
}

// 힌트 class
class HintCalculator {
    // answer =정답 배열, userGuess= 사용자가 추측한 배열
    func calculateHints(answer: [Int], userGuess: [Int]) -> (strike: Int, ball: Int) {
        
        // 스트라이크 계산
        let strikeCount = zip(answer, userGuess).map { (answerNumber, guessedNumber) in
            return answerNumber == guessedNumber ? 1 : 0 }.reduce(0, +)
        
        // 볼 계산
        let ballCount = userGuess.filter { guessedNumber in
            answer.contains(guessedNumber)
        }.count - strikeCount
        
        return (strikeCount, ballCount)
    }
}


// BaseballGame 클래스
class BaseballGame {
    private let answerGenerator = AnswerGenerator()
    private let inputHandler = InputHandler()
    private let hintCalculator = HintCalculator()
    
    // 게임 시작 함수
    func start() {
        let answer = answerGenerator.generate()
        print("⚾️ 숫자 야구 게임 시작~! 세 자리 숫자를 입력하세요! ⚾️")
        
        while true {
            do {
                let userInput = try inputHandler.getInput() // 오류가 발생할 수 있는 부분
                // userInput에서 받은 문자열을 배열로 변환
                let userGuess = userInput.compactMap { Num in Int(String(Num)) }
                // 입력받은 정수를 정답과 비교하여 안내
                let (strike, ball) =
                hintCalculator.calculateHints(answer: answer, userGuess: userGuess)
                print("\(strike) 스트라이크, \(ball) 볼 ")
                
                // 맞출 경우, 그게 아니라면 나오는 print 작성
                if strike == 3 {
                    print("🎉🎉🧢홈⚾️런🧢🎉🎉")
                    break
                } else {
                    print("아까비.. 다시!!!")
                }
                // 오류메세지
            } catch InputError.emptyInput {
                print("아무것도 입력하지 않으셨습니다.")
            } catch InputError.notANumber {
                print("숫자가 아닙니다.")
            } catch InputError.numLimit {
                print("세 자리 숫자를 입력해주세요.")
            } catch InputError.duplicated {
                print("숫자 중복 없이 입력해주세요.")
            } catch {
                print("알 수 없는 오류가 발생했습니다.")
            }
        }
    }
}


// 실행 인스턴스 생성
let game = BaseballGame()
game.start()

