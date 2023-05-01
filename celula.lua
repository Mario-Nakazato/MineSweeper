local function nova(i, j, x, y, l)
  
  objeto = {}
  objeto.i = i
  objeto.j = j
  objeto.l = l
  objeto.x = (i +x) *l
  objeto.y = (j +y) *l
  objeto.visivel = false
  objeto.mina = false
  objeto.bandeira = false
  objeto.contagemMina = 0
  objeto.fonte = lgrafico.newFont(l /2)
  
  function objeto:desenhar()
    
    lgrafico.setColor(corByte(0, 0, 0))
    lgrafico.rectangle("line", self.x, self.y, self.l, self.l)
    lgrafico.setColor(corByte(95, 95, 95))
    lgrafico.rectangle("fill", self.x +1, self.y +1, self.l -1, self.l -1)
    if self.visivel then
      lgrafico.setColor(corByte(159, 159, 159))
      lgrafico.rectangle("fill", self.x +1, self.y +1, self.l -1, self.l -1)
      lgrafico.setColor(corByte(0, 0, 0))
      if self.mina then
        lgrafico.circle("line", self.x +self.l *0.5, self.y +self.l *0.5, self.l *0.25)
      else
        if self.contagemMina > 0 then
          lgrafico.setFont(self.fonte)
          lgrafico.print(self.contagemMina, self.x +self.l*0.35, self.y +self.l*0.25)
        end
      end
    end
    lgrafico.setColor(corByte(255, 69, 0))
    if self.bandeira then
      lgrafico.circle("fill", self.x +self.l *0.5, self.y +self.l *0.5, self.l *0.125)
    elseif self.bandeira == nil then
      lgrafico.line(self.x, self.y, self.x+ self.l, self.y+ self.l)
      lgrafico.line(self.x +self.l, self.y, self.x, self.y+ self.l)
    end
    
  end
  
  function objeto:selecionar(x, y)
  
    return (x > self.x and x < self.x +self.l and y > self.y and y < self.y +self.l)
  
  end

  function objeto:mostrar()
    
    abriu = 0
    if not self.visivel and not self.bandeira then
      self.visivel = true
      if not self.mina and self.contagemMina == 0 then
        abriu = abriu +self:mostrarVisinho()
      end
      abriu = abriu +1
    end
    
    return abriu
    
  end
  
  function objeto:contarMina()
    
    if self.mina then
      return
    end
    
    total = 0
    
    for i = -1, 1 do
      for j = -1, 1 do
        if grade[self.i +i] then
          if grade[self.i +i][self.j +j] then
            if grade[self.i +i][self.j +j].mina then
              
              total = total +1
              
            end
          end
        end
      end
    end
    
    self.contagemMina = total
    
  end
  
  function objeto:mostrarVisinho()
    
    abriu = 0
    for i = -1, 1 do
      for j = -1, 1 do
        if grade[self.i +i] then
          if grade[self.i +i][self.j +j] then
            if not grade[self.i +i][self.j +j].visivel and not grade[self.i +i][self.j +j].mina then
              
              abriu = abriu +grade[self.i +i][self.j +j]:mostrar()
              
            end
          end
        end
      end
    end
    
    return abriu
    
  end
  
  return objeto
  
end
  
celula = {
  
  nova = nova,
  
}

return celula