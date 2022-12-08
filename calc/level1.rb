'
①エラーチェック
(a)数式の先頭、末尾が数値以外の場合エラーを返す
(b)数式内で"+","-","*","/"が連続した場合エラーを返す
(c)数式に[0-9],"+","-","*","/"以外の文字が含まれていた場合エラーを返す

②字句解析
(a)入力した数式について、演算子を以下の通り一文字づつ変換する。
"+" → a
"-" → s
"*" → m
"/" → d
(例)
3*2+1-4/2 → 3m2a1s4d2
12/2+2*3 → 12d2a2m3

(b)連続数を数値として判別し配列に格納する。
(例)
3*2+1-4/2 → "3","m","2","a","1","s","4","d","2"
12/2+2*3 → "12","d","2","a","2","m","3"


③構文解析
(a)数式の計算順を定める。
②で変換した文字の配列を"tokens"と定義する。
また、数式の計算順を記憶する配列を"queue"と定義する。
(ア)tokensの先頭の要素から確認し、m,dが出現したらその要素番号をqueueに格納する。
(イ)(ア)完了後、再度tokensの先頭の要素から確認し、a,sが出現したらその要素番号をqueueに格納する。

(b)queueに格納された計算順に従いtokensを計算する。
queue.shiftで得られた要素番号について、該当の演算子および前後の数値を取得し計算する。
計算が完了した要素は、その計算結果をtokensに上書きし残りを削除する。
(例)
tokens[0] = 2, tokens[1] = *, tokens[2] = 3 の時、
tokens[0] = 6
として、tokens[1],tokens[2]は削除する。

また、queueにおいて該当の要素番号より大きい演算子が存在する場合、その演算子の要素番号を-2する。（前に詰める）
これをqueueが空になるまで繰り返す。
上記処理の返り値が入力した数式の出力となる。


'

class Calc

  def initialize
    if __FILE__ == $0
      input = gets.chomp
      puts calc_main(input)
    end
  end

  def calc_main(input)
    checkResult = checkFormula(input)
    if checkResult != nil then
      return checkResult
    else
      tokens = lexicalAnalysis(input)
      return syntaxAnalysis(tokens)
    end
  end


  def checkFormula(formula)
    #(a)数式に[0-9],"+","-","*","/"以外の文字が含まれていた場合エラーを返す
    #(b)数式の先頭、末尾が数値以外の場合エラーを返す
    if (formula =~ /^[0-9][0-9\*\+\-\/]*[0-9]$/) == nil then
      return "Error Message 1 : Formula is not appropriate"
      exit
    end
    #(c)数式内で"+","-","*","/"が連続した場合エラーを返す
    setArray(formula)
    preC = ''
    @formulaArray.each do |c|
      if c.match(/[0-9]/) != nil then
        preC = 'D'
      elsif preC == 'O' then
        return "Formula is not appropriate"
        exit
      else
        preC = 'O'
      end
    end
    return nil
  end

  def lexicalAnalysis(formula)
    #(a)入力した数式について、一文字づつ変換する。
    #(b)連続数を数値として判別し配列に格納する。
    setArray(formula)
    return firstConversion(@formulaArray)
  end

  def firstConversion(array)
    tokens = []
    preC = ''
    array.each do |c|
      if c.match(/[0-9]/) then
        #数字が連続する場合、preCに結合していくことで対応
        preC = fixInteger(preC,c)
      else
        #演算子の場合、preCが数値で確定するので配列に格納
        tokens << preC.to_f
        preC = c
        case c
        when '+' then
          tokens << 'a'
        when '-' then
          tokens << 's'
        when '*' then
          tokens << 'm'
        when '/' then
          tokens << 'd'
        end
      end 
    end
    tokens << preC.to_f
    return tokens
  end

  def fixInteger(preC,c)
    if preC.match(/[0-9]/) then
      preC = preC + c
    else
      preC = c
    end
    return preC
  end

  def syntaxAnalysis(tokens)
    #queueを作成する
    queue = setQueue(tokens)
    num = queue.length
    num.times do
      opeNum = queue.shift
      #計算後、tokensを更新
      tokens[opeNum - 1] = atomCalc(tokens[opeNum],tokens[opeNum - 1],tokens[opeNum + 1])
      tokens.slice!(opeNum,2)
      #queueを更新
      queue.each_with_index do |e,i|
        if e > opeNum then
          queue[i] = e - 2
        end
      end
    end
    return tokens[0]
  end


  def setQueue(tokens)
    queue = []
    tokens.each_with_index do |c,i|
      if c == 'm' || c == 'd' then
        queue << i
      end
    end
    tokens.each_with_index do |c,i|
      if c == 'a' || c == 's' then
        queue << i
      end
    end
    return queue
  end

  def atomCalc(ope,num1,num2)
    case ope 
    when 'a' then
      return num1 + num2
    when 's' then
      return num1 - num2
    when 'm' then
      return num1 * num2
    when 'd' then
      return num1 / num2
    end
  end

  def setArray(formula)
    @formulaArray = formula.split("")
  end

end

Calc.new
