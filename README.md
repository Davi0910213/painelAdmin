# painelAdmin# 🎮 AdminPanel Roblox - Painel de Administração Indetectável

Um painel de admin poderoso e **indetectável** para Roblox com encurtador de URL integrado.

## ✨ Funcionalidades

### 🔧 Comandos de Admin
- 🚀 **Voar** - Voe livremente com WASD, SPACE e CTRL
- 💀 **Matar** - Elimine jogadores selecionados
- 🚫 **Banir** - Banir jogadores do servidor
- 👁️ **Ver Visão** - Veja a câmera de outro jogador
- 👑 **Promover Admin** - Procure sistema de admin e se auto-promova
- 📦 **Puxar Itens** - Puxe itens específicos ou todos de uma vez
- ⚡ **Controlar Velocidade** - Aumente/diminua velocidade do voo

### 🔗 Encurtador de URL
- **TinyURL** - Encurtador clássico
- **is.gd** - Rápido e confiável
- **vgd.me** - Alternativa online
- **Local** - Método offline

## 🚀 Como Usar

### Instalação
1. Copie `AdminPanel.lua` para seu projeto Roblox
2. Coloque em: `StarterPlayer > StarterPlayerScripts > LocalScript`

### Execução
1. Pressione **F9** para abrir/fechar o painel
2. Digite o nome do jogador/item nos campos
3. Clique em **✓** para confirmar
4. Use os botões de comando

### Encurtador de URL
1. Clique em **🔗 Encurtar URL**
2. Cole a URL longa
3. Clique em **Encurtar**
4. Copie o resultado

## 🛡️ Recursos de Anti-Detecção

✅ Nomes aleatórios para objetos
✅ Sem prints visíveis
✅ Movimentos graduais (não instantâneos)
✅ Kills progressivos
✅ Ofuscação de código
✅ Protecção de tabelas
✅ Delays aleatórios
✅ Try-catch em tudo
✅ Limpeza de memória
✅ Invisível no explorador

## 📦 Estrutura do Painel

| Seção | Função |
|-------|--------|
| **JOGADOR** | Selecionar jogador alvo |
| **ITEM** | Selecionar item alvo |
| **COMANDOS** | Executar ações |

## ⚙️ Customização

### Adicionar mais admins
```lua
local admins = {"Davi0910213", "OutroJogador", "MaisUm"}
```

### Mudar hotkey (F9)
```lua
if input.KeyCode == Enum.KeyCode.F10 then  -- Mude para F10
    mainFrame.Visible = not mainFrame.Visible
end
```

### Ajustar velocidade padrão do voo
```lua
local flySpeed = 100  -- Aumente de 50 para 100
```

## 📋 Exemplos de Uso

**Voar:**
1. Clique em "🚀 Voar"
2. Use WASD para se mover
3. SPACE para subir, CTRL para descer

**Matar Jogador:**
1. Digite nome do jogador em "👥 JOGADOR"
2. Clique em ✓
3. Clique em "💀 Matar"

**Puxar Items:**
1. Digite nome do item em "📦 ITEM"
2. Clique em ✓
3. Clique em "📦 Puxar Item Específico"
4. Ou clique em "🌍 Puxar TODOS os Itens"

**Encurtar URL:**
1. Clique em "🔗 Encurtar URL"
2. Cole URL longa
3. Clique em "Encurtar"
4. Copie resultado

## ⚠️ Aviso Legal

Este script é fornecido **APENAS PARA FINS EDUCACIONAIS**. 
O uso em servidores públicos pode violar os Termos de Serviço do Roblox.
Use apenas em:
- Seus próprios jogos/servidores privados
- Ambientes de teste
- Jogo solo

## 📝 Licença

MIT License - Veja LICENSE para detalhes

## 👨‍💻 Autor

Criado por **Davi0910213**

Com assistência do **GitHub Copilot**

## 🤝 Contribuições

Sugestões e melhorias são bem-vindas! Abra uma issue ou faça um PR.

## 📞 Suporte

Encontrou um bug? Abra uma issue com:
- Descrição do problema
- Passos para reproduzir
- Versão do Roblox
- Logs de erro (se houver)

---

**⭐ Se gostou, deixe uma star! ⭐**
