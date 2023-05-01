--celula = require "celula"
require "celula"

function love.load(arg)
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- ZeroBrane Studio para Debug
  
  lgrafico = love.graphics
  lmath = love.math
  
  corByte = lmath.colorFromBytes
  
  update = false
  draw = true
  mousepressed = true
  
  ciclo = 0
  tick = 0
  ticks = 0
  
  segundo = 0
  minuto = 0
  hora = 0
  
  lado = 32--80
  linha = 16--28--10--28
  coluna = 16--58--10--58
  
  love.window.updateMode(lado *coluna +16, lado *linha +16 +64 +8)
  ct, lt = lgrafico.getDimensions()
  
  level = 1
  txt = "Level: " ..level
  
  timer = {}
  timer.c = 128
  timer.l = 64
  timer.x = math.floor((ct -timer.c) /2)
  timer.y = 8
  timer.txt = "0000"
  timer.fonte = lgrafico.newFont(timer.l /2)
  function timer:contar(seg)
    seg = seg%10000
    if seg < 10 then
      self.txt = "000" ..seg
    elseif seg >= 10 and seg < 100 then
      self.txt = "00" ..seg
    elseif seg >= 100 and seg < 1000 then
      self.txt = "0" ..seg
    else
      self.txt = seg
    end
  end
  
  x, y = (ct -lado *coluna) /lado /2 -1, (lt -8 -lado *linha) /lado -1
  
  grade = {}
  
  for i = 1, coluna do
    grade[i] = {}
    for j = 1, linha do
      grade[i][j] = celula.nova(i, j, x, y, lado)
    end  
  end
  
  mina = 32
  bandeiras = mina
  while mina > 0 do
    i, j = lmath.random(coluna), lmath.random(linha)
    if not grade[i][j].mina then
      grade[i][j].mina = true
      mina = mina -1
    end
  end
  mina = bandeiras
  
  for i = 1, coluna do
    for j = 1, linha do
      grade[i][j]:contarMina()
    end  
  end
  
  abriu = 0
  
end

function love.update(dt)
  
  if not update then
    return
  end
  
  timer:contar(math.floor(ticks))
  
  ciclo = ciclo +1
  tick = dt
  ticks = ticks +tick
  segundo = math.floor(ticks) %60
  minuto = math.floor(ticks /60) %60
  hora = math.floor(ticks /3600)
  
end

function love.draw()
  
  if not draw then
    return
  end
  
  lgrafico.setBackgroundColor(corByte(0, 108, 0))
  lgrafico.setLineStyle("smooth")
  lgrafico.setLineWidth(4)
  
  lgrafico.setColor(corByte(0, 0, 0))
  lgrafico.rectangle("line", (ct -lado *coluna) /2, 8, lado *coluna, 64)
  
  lgrafico.setFont(timer.fonte)
  lgrafico.setColor(corByte(255, 69, 0))
  lgrafico.circle("fill", timer.x -100, timer.y +32, lado *0.125)
  lgrafico.setColor(corByte(0, 0, 0))
  lgrafico.print(bandeiras, timer.x -72, timer.y +timer.l *0.2)
  
  lgrafico.rectangle("line", timer.x, timer.y, timer.c, timer.l)
  lgrafico.print(timer.txt, timer.x +timer.c *0.2, timer.y +timer.l *0.2)
  
  lgrafico.print(txt, timer.x +140, timer.y +timer.l *0.2)
  
  for i = 1, coluna do
    for j = 1, linha do
      grade[i][j]:desenhar()
    end  
  end
  
end

function love.keypressed(tecla, cod, repeticao)
  
  if tecla == "kp+" and level < 10 then
    level = level +1
    txt = "Level: " ..level
  elseif tecla == "kp-" and level > 1 then
    level = level -1
    txt = "Level: " ..level
  end
  
  if tecla == "f5" then
    love.load({})
  elseif tecla == "f6" then
    update = false
    mousepressed = false
    for i = 1, coluna do
      for j = 1, linha do
        
        if not grade[i][j].mina and grade[i][j].bandeira then
          grade[i][j].bandeira = nil
        else
          grade[i][j].visivel = true
        end
        
      end
    end
  end
  
end

function love.keyreleased(tecla, cod)
  
  
  
end

function love.mousepressed(x, y, botao, toque, repeticao)
  
  if not mousepressed then
    return
  end
  
  for i = 1, coluna do
    for j = 1, linha do
      
      if grade[i][j]:selecionar(x, y) then
        if botao == 1 and not grade[i][j].bandeira then
          update = true
          if grade[i][j].mina then
            
            mousepressed = false
            txt = "Perdeu!"
            for i = 1, coluna do
              for j = 1, linha do
                
                if grade[i][j].mina then
                  update = false
                   abriu = abriu +grade[i][j]:mostrar()
                else
                  if grade[i][j].bandeira then
                    grade[i][j].bandeira = nil
                  end
                end
                
              end  
            end
            
          else
            abriu = abriu +grade[i][j]:mostrar()
          end
        elseif botao == 2 then
          if not grade[i][j].visivel then
            grade[i][j].bandeira = not grade[i][j].bandeira
            if grade[i][j].bandeira then
              bandeiras = bandeiras -1
            elseif not grade[i][j].bandeira and bandeiras < mina then
              bandeiras = bandeiras +1
            end
          end
        end
        break
      end
      
    end
  end
  
  if abriu == coluna *linha -mina then
    update = false
    mousepressed = false
    txt = "Ganhou!"
    
  end
  
end

function love.mousereleased(x, y, botao, toque, repeticao)
  
  
  
end

function love.mousemoved(x, y, dx, dy, toque)
  
  
  
end

function love.wheelmoved(x, y)
  
  
  
end

function love.mousefocus(foco)
  
  
  
end

function love.resize(c, l)
  
  
  
end

function love.focus(foco)
  
  
  
end

function love.quit()
  
  
  
end
--[[
function inicioContato(a, b, contato) 
  
  
  
end

function fimContato(a, b, contato)
  
  
  
end

function preContato(a, b, contato)
  
  
  
end

--function posContato(a, b, contato, normalImpulso, tangenteImpulso, normalImpulso1, tangenteImpulso1)
function posContato(a, b, contato, normalImpulso, tangenteImpulso)
  
  
  
end

function love.touchpressed(id, x, y, dx, dy, pressao)
  
  
  
end

function love.touchreleased(id, x, y, dx, dy, pressao)
  
  
  
end

function love.touchmoved(id, x, y, dx, dy, pressao)
  
  
  
end

function love.displayrotated(indice, orientacao)
  
  
  
end

function love.textedited(texto, inicio, tamanho)
  
  
  
end

function love.textinput(texto)
  
  
  
end

function love.directorydropped(caminho)
  
  
  
end

function love.filedropped(arquivo)
  
  
  
end

function love.errorhandler(erro)
  
  
  
end

function love.lowmemory()
  
  
  
end

function love.threaderror(thread, erro)
  
  
  
end

function love.visible(visivel)-- Esta funcao CallBack não funciona, utilize visivel = love.window.isMinimized()
end
--]]