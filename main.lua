local celula = require("celula")

local larguraTela = 500
local alturaTela = 500
local tamanhoCelula = 25
grade = {}
local jogando = true
local totalCelulas = larguraTela / tamanhoCelula * alturaTela / tamanhoCelula
local totalMinas = math.floor(totalCelulas / 6)
local numeroMinas = 0
local fontePontuacao
local tempoInicio = 0
local pontuacao = 0

function love.load()
  love.window.setTitle("Campo Minado")
  love.window.setMode(larguraTela, alturaTela)
  love.graphics.setBackgroundColor(converterCor(255, 255, 255))

  fontePontuacao = love.graphics.newFont(30)

  for i = 0, larguraTela / tamanhoCelula - 1 do
    grade[i] = {}

    for j = 0, alturaTela / tamanhoCelula - 1 do
      grade[i][j] = celula.nova(i, j, tamanhoCelula)
    end
  end

  while numeroMinas < totalMinas do
    local i = love.math.random(0, larguraTela / tamanhoCelula - 1)
    local j = love.math.random(0, alturaTela / tamanhoCelula - 1)

    if not grade[i][j].mina then
      grade[i][j].mina = true
      numeroMinas = numeroMinas + 1
    end
  end
end

function love.update(dt)
  if jogando then
    pontuacao = math.floor(love.timer.getTime() - tempoInicio)
  end
end

function love.draw()
  for i = 0, larguraTela / tamanhoCelula - 1 do
    for j = 0, alturaTela / tamanhoCelula - 1 do
      grade[i][j]:desenhar()
    end
  end

  love.graphics.setFont(fontePontuacao)
  love.graphics.print("Pontuação: " .. pontuacao, 10, 10)
end

function love.mousepressed(x, y, button)
  if button ~= 1 or not jogando then
    return
  end

  for i = 0, larguraTela / tamanhoCelula - 1 do
    for j = 0, alturaTela / tamanhoCelula - 1 do
      if grade[i][j]:selecao(x, y) then
        grade[i][j]:mostrar()

        if grade[i][j].mina then
          jogando = false
          tempoInicio = 0
        elseif verificarVitoria() then
          jogando = false
        end
      end
    end
  end

  if not tempoInicio then
    tempoInicio = love.timer.getTime()
  end
end

function verificarVitoria()
  for i = 0, larguraTela / tamanhoCelula - 1 do
    for j = 0, alturaTela / tamanhoCelula - 1 do
      if not grade[i][j].visivel and not grade[i][j].mina then
        return false
      end
    end
  end

  return true
end

function converterCor(r, g, b)
  return r / 255, g / 255, b / 255
end
