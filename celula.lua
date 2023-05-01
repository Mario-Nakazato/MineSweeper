local celula = {}

celula.numeroMinas = 0
celula.totalMinas = 10

function celula.nova(i, j, l)

  local objeto = {}
  
  objeto.i = i
  objeto.j = j
  objeto.x = i *l
  objeto.y = j *l
  objeto.l = l
  objeto.visivel = false
  objeto.contagem = 0
  objeto.fonte = love.graphics.newFont(objeto.l/2)

  if love.math.random() < 0.1 and celula.numeroMinas < celula.totalMinas then
  
    objeto.mina = true
    celula.numeroMinas = celula.numeroMinas +1
  
  else

    objeto.mina = false
  
  end

  function objeto:desenhar()
    
    love.graphics.setColor(converterCor(0, 0, 0))
    love.graphics.rectangle("line", self.x, self.y, self.l, self.l)
  
    if self.visivel then
      if self.mina then
        
        love.graphics.setColor(converterCor(163, 163, 163))
        love.graphics.rectangle("fill", self.x +2, self.y +2, self.l -2, self.l -2)
        love.graphics.setColor(converterCor(107, 107, 107))
        love.graphics.circle("fill", self.x +self.l*0.5, self.y +self.l*0.5, self.l*0.25)
        love.graphics.setColor(converterCor(118, 118, 118))
        love.graphics.circle("fill", self.x +self.l*0.5, self.y +self.l*0.5, self.l*0.1)
      
      else
        
        love.graphics.setColor(converterCor(163, 163, 163))
        love.graphics.rectangle("fill", self.x +2, self.y +2, self.l -2, self.l -2)
        love.graphics.setColor(converterCor(0, 0, 0))
        
        if self.contagem > 0 then
          
          love.graphics.setFont(self.fonte)
          love.graphics.print(self.contagem, self.x +self.l*0.4, self.y +self.l*0.4)
        
        end
      end
    end
  end
  
  function objeto:selecao(x, y)
    
    return (x > self.x and x < self.x +self.l and y > self.y and y < self.y +self.l)
    
  end
  
  function objeto:contarMina()
    
    if self.mina then
      
      return -1
      
    end
    
    total = 0
    
    for i = 0, 2 do
      for j = 0, 2 do
        if grade[self.i +i] then
          if grade[self.i +i][self.j +j] then
            if grade[self.i +i][self.j +j].mina then
          
              total = total +1
          
            end
          end
        end
      end
    end
    
    self.contagem = total
    
  end
  
  function objeto:mostrar()
      
      self.visivel = true
      if self.contagem == 0 and not self.mina then
        
        self:mostrarVisinho()
      
      end
  end
  
  function objeto:mostrarVisinho()
    
    for i = 0, 2 do
      for j = 0, 2 do
        if grade[self.i +i] then
          if grade[self.i +i][self.j +j] then
            if not grade[self.i +i][self.j +j].visivel and not grade[self.i +i][self.j +j].mina then
          
              grade[self.i +i][self.j +j]:mostrar()
          
            end
          end
        end
      end
    end
  end
  
  return objeto

end

return celula