
function GM:OpenMainMenu()
    if self.MainMenuPnl and self.MainMenuPnl:IsValid() then return end

    self.MainMenuPnl = vgui.Create("Panel")
    self.MainMenuPnl:SetSize(ScrW(), ScrH())
end

function GM:CloseMainMenu()
    if not self.MainMenuPnl or !self.MainMenuPnl:IsValid() then return end
    self.MainMenuPnl:Remove()
end

function GM:ToggleMainMenu()
    if self.MainMenuPnl and self.MainMenuPnl:IsValid() then
        self:OpenMainMenu()
    else
        self:CloseMainMenu()
    end
end

hook.Add("OnPauseMenuShow", "Hl2ce.MainMenu", function()
    GAMEMODE:ToggleMainMenu()

    return false
end)
