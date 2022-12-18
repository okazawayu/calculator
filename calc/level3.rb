'
①エラーチェック
(a)数式に[0-9],"+","-","*","/","E","."以外の文字が含まれていた場合エラーを返す
(b)数式の先頭が数字もしくは"("、末尾が数字もしくは")"以外の場合エラーを返す
(c)数式内で"+","-","*","/","E","."が連続した場合エラーを返す
(d)数式を左から確認し、")"の個数が"("を超過した場合エラーを返す
(e)")"の個数と"("の個数が異なっていた場合エラーを返す
(f)以下の規則から外れていた場合、エラーを返す
・"("の前は演算子,"E","("のいずれかであること
・"("の後ろは数字,"("のいずれかであること
・")"の前は数字,")"のいずれかであること
・")"の後ろは演算子、"E",")"のいずれかであること


②字句解析
(a)入力した数式について、演算子、指数表記、括弧を以下の通り一文字づつ変換する。
"+" → a
"-" → s
"*" → m
"/" → d
"E" → e
"(" → l
")" → r
(例)
3*2+1-4/2 → 3m2a1s4d2
12/2+2*3 → 12d2a2m3
3.2*2+2.1/7+2E2 →3.2m2a2.1d7a2e2
3*(2+1)E2 →3ml2a1re2

(b)連続した数字（数字間に小数点が含まれている場合も含む）を数値として判別し配列に格納する。
この時、演算子間に"."が2回以上含まれていた場合エラーを返す。
(例)
3*2+1-4/2 → "3","m","2","a","1","s","4","d","2"
12/2+2*3 → "12","d","2","a","2","m","3"
3.2*2+2.1/7+2E2 → "3.2","m","2","a","2.1","d","7","2","e","2"
1.2.3*2 → エラー

③構文解析
(a)()内を再帰的に計算する。
②で変換した文字の配列を"tokens"と定義する。
”l”と”r”で囲まれた部分を"block"と定義する。
tokensを先頭から確認し、”l”が出現したら"r"が出現するまで探索を続ける。
途中"l"が出現した場合、再帰的に探索する。
対応する"l"~"r"が確認できたら、そのblockを計算する。


(b)数式の計算順を定める。
(e) → (m,d) → (a,s)の順で計算する。
数式の計算順を記憶する配列を"queue"と定義する。
(ア)tokensの先頭の要素から確認し、m,dが出現したらその要素番号をqueueに格納する。
(イ)(ア)完了後、再度tokensの先頭の要素から確認し、a,sが出現したらその要素番号をqueueに格納する。

(c)queueに格納された計算順に従いtokensを計算する。
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
    #コマンドラインから入力された時、標準入出力を受け付ける。(テスト時には受け付けない。)
    if __FILE__ == $0
      input = gets.chomp
      puts calc_main(input)
    end
  end

  def calc_main(input)
    #数式が正しくない場合はエラーメッセージを表示する。
    checkResult = checkFormula(input)
    if checkResult != nil then
      return outputErrorMessage(checkResult)
    else
      @tokens = lexicalAnalysis(input)
      if !@tokens.instance_of?(Array) then
        return outputErrorMessage(@tokens)
      else 
        block = []
        while !@tokens.empty? do
          c = @tokens.shift
          if c == 'l' then
            block.concat(calculateParenthesis([]))
          else
            block << c
          end
        end
      end
      return syntaxAnalysis(block)
    end
  end


  def checkFormula(formula)
    #(a)数式に[0-9],"+","-","*","/","E","."以外の文字が含まれていた場合エラーを返す
    #(b)数式の先頭、末尾が数字以外の場合エラーを返す
    if (formula =~ /^[0-9()][0-9\*\+\-\/\E\.()]*[0-9)]$/) == nil then
      return "Error1"
    end
    #(c)数式内で"+","-","*","/","E","."が連続した場合エラーを返す
    setArray(formula)
    preC = ''
    pNum = 0
    @formulaArray.each do |c|
      if c.match(/[0-9]/) != nil then
        preC = 'D'
      elsif c == '(' then
        pNum +=1
        preC = 'l'
      elsif c == ')' then
        pNum -=1
        #(d)数式を左から確認し、")"の個数が"("を超過した場合エラーを返す
        if pNum < 0 then
          return "Error4"
        end
        preC = 'r'
      else
        if preC == 'O' then
          return "Error2"
        end
        preC = 'O'
      end
    end
    #(e)")"の個数と"("の個数が異なっていた場合エラーを返す
    if pNum != 0 then
      return "Error5"
    end
    # (f)以下の規則から外れていた場合、エラーを返す
    # ・"("の前が数字、")"、"."の場合エラーを返す
    # ・"("の後ろが演算子、")"、"."、"E"の場合エラーを返す
    # ・")"の前が演算子、"("、"E"、"."の場合エラーを返す
    # ・")"の後ろが数字、"."、"("の場合エラーを返す 
    preC = ''
    @formulaArray.each do |c|
      if c == '(' then
        if preC.match(/[0-9]/) != nil || preC ==  'r' || preC ==  'd' 
          return "Error6"
        end
        preC = 'l'
      elsif c == ')' then
        if preC ==  'l' || preC ==  'e' || preC ==  'd' || preC == 'o'
          return "Error6"
        end
        preC = 'r'
      elsif c == '.' then
        if preC == 'l' || preC == 'r' 
          return "Error6"
        end
        preC = 'd'
      elsif c == 'E' then
        if preC == 'l' then
          return "Error6"
        end
        preC = 'e'
      elsif c.match(/[0-9]/) != nil then
        if preC == 'r' then
          return "Error6"
        end
        preC = c
      else
        if preC == 'l' then
          return "Error6"
        end
        preC = 'o'
      end 
    end
    return nil
  end

  def lexicalAnalysis(formula)
    #(a)入力した数式について、一文字づつ変換する。
    #(b)連続数を数値として判別し配列に格納する。
    setArray(formula)
    tokens = []
    preC = ''
    @countD = 0
    @formulaArray.each do |c|
      if c.match(/[0-9\.]/) then
        #数字が連続する場合、preCに結合していくことで対応
        preC = fixInteger(preC,c)
        if preC == "Error3" then
          return "Error3"
        end
      else
        if preC.match(/[0-9]/) then
          #演算子の場合、preCが数値で確定するので配列に格納
          tokens << preC.to_f
          @countD = 0
          preC = c
        end
        case c
        when '+' then
          tokens << 'a'
        when '-' then
          tokens << 's'
        when '*' then
          tokens << 'm'
        when '/' then
          tokens << 'd'
        when 'E' then
          tokens << 'e'
        when '(' then
          tokens << 'l'
        when ')' then
          tokens << 'r'
        end
      end 
    end
    if preC.match(/[0-9]/) then
      tokens << preC.to_f
    end
    return tokens
  end

  def fixInteger(preC,c)
    if preC.match(/[0-9\.]/) then
      preC = preC + c
    else
      preC = c
    end
    #演算子間に"."が2回以上含まれていた場合エラーを返す。
    if c.match(/[\.]/) then
      @countD += 1 
      if @countD >= 2 then
        return "Error3"
      end
    end
    return preC
  end

  def calculateParenthesis(outerBlock)
    #(a)()内を再帰的に計算する。
    innerBlock = []
    while !@tokens.empty? do
      c = @tokens.shift
      if c == 'l' then
        outerBlock = calculateParenthesis(innerBlock)
      elsif c == 'r' then
        outerBlock << syntaxAnalysis(innerBlock)
        return outerBlock
      else
        innerBlock << c
      end
    end
  end

  def syntaxAnalysis(tokens)
    #queueを作成する
    queue = setQueue(tokens)
    num = queue.length
    #(c)queueに格納された計算順に従いtokensを計算する。
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
    #(b)数式の計算順を定める。
    #(e) → (m,d) → (a,s)の順で計算する。
    queue = []
    tokens.each_with_index do |c,i|
      if c == 'e' 
        queue << i
      end
    end
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
    when 'e' then
      return num1 * (10 ** num2)
    end
  end

  def setArray(formula)
    @formulaArray = formula.split("")
  end

  def outputErrorMessage(errorNum)
    case errorNum
    when "Error1" then
      return "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    when "Error2" then
      return "Error Message 2 : 数式内で'+','-','*','/','E','.'が連続して入力されています"
    when "Error3" then
      return "Error Message 3 : 演算子間に'.'が2回以上入力されています"
    when "Error4" then
      return "Error Message 4 : 数式の途中で')'の個数が'('を超過しています"
    when "Error5" then
      return "Error Message 5 : ')'の個数と'('の個数が異なります"
    when "Error6" then
      return "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    end
  end
end

Calc.new
