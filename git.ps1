###ha nem müködne akkor elsõnek futtatni ::: Set-ExecutionPolicy RemoteSigned
### aktuális felhasználó esetében ::: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

#[Console]::OutputEncoding
###CONF :::
$USERNAME      = 'dggmester'
$USERMAIL      = 'janos.fejleszto@gmail.com'
$REPONAME      = 'psGUI_git'
$GH            = 'https://github.com/'
$GL            = 'https://gitlab.com/'
$GIT           = 'git'

###ENT  :::
$userLinkGH    = $GH+$USERNAME
$userLinkGL    = $GL+$USERNAME
$repoLinkGH    = $GH+$USERNAME+'/'+$REPONAME+'.git'
$repoLinkGL    = $GL+$USERNAME+'/'+$REPONAME+'.git'
$label         = 'GIT: '+$USERNAME+':::'+$REPONAME
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference                     = 'SilentlyContinue'
$wshell                                    = New-Object -ComObject Wscript.Shell
$Button                                    = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco                                  = [System.Windows.MessageBoxImage]::Error
$Form                                      = New-Object system.Windows.Forms.Form
#$Form.ClientSize                           = New-Object System.Drawing.Point(700,200) #magasság,szélesség
$Form.text                                 = $label
$Form.StartPosition                        = "CenterScreen"
$Form.TopMost                              = $false
$Form.BackColor                            = [System.Drawing.ColorTranslator]::FromHtml("#e9e9e9")
$Form.AutoScaleDimensions                  = '192, 192'
$Form.AutoScaleMode                        = "Dpi"
$Form.AutoSize                             = $true
$Form.AutoScroll                           = $True
$Form.FormBorderStyle                      = 'FixedSingle'
$Form.Width                                = $objImage.Width
$Form.Height                               = $objImage.Height

#Panelek:::
$x_left                                    = 0
$y_top                                     = 0
$margin_left                               = 5
$margin_top                                = 5
$d_left                                    = 200
$d_top                                     = 15

#default panel
$Panel_default                             = New-Object system.Windows.Forms.Panel
$Panel_default.height                      = 200
$Panel_default.width                       = $d_left-$margin_left+200 #szélesség
$Panel_default.location                    = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))

###következõ panel elõtt:
#lefele::: $y_top          = $y_top + 200
#jobbra::: $x_left         = $x_left + $d_left
#fel   ::: $y_top          = 0
$Form.controls.AddRange(@($Panel_default)) ###vesszõvel választjuk el ha több panel van

#Panelek tartalma
$x_left                                    = 0
$y_top                                     = 0
$margin_left                               = 5
$margin_top                                = 5
$d_left                                    = 180
$d_top                                     = 50

###INIT:
$gitHub_init                                    = New-Object system.Windows.Forms.Button
$gitHub_init.text                               = "GITLAB ::: init"
$gitHub_init.width                              = $d_left-5
$gitHub_init.height                             = $d_top-5
$gitHub_init.location                           = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$gitHub_init.Font                               = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$Panel_default.Controls.Add($gitHub_init)
$gitHub_init.Add_Click({
	Write-Host "BEGIN ::: gitLAB_init!"
	& $GIT config --global user.name $USERNAME
	& $GIT config --global user.email $USERMAIL
	& $GIT init
	& $GIT remote add origin $repoLinkGL
	& $GIT add .
	Write-Host "END!"
})
$x_left                                         = $x_left + 200
$gitLAB_init                                    = New-Object system.Windows.Forms.Button
$gitLAB_init.text                               = "GITHAB ::: init"
$gitLAB_init.width                              = $d_left-5
$gitLAB_init.height                             = $d_top-5
$gitLAB_init.location                           = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$gitLAB_init.Font                               = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$Panel_default.Controls.Add($gitLAB_init)
$gitLAB_init.Add_Click({
	Write-Host "BEGIN ::: gitHAB_init!"
	& $GIT config --global user.name $USERNAME
	& $GIT config --global user.email $USERMAIL
	& $GIT init
	& $GIT remote add origin $repoLinkGH
	& $GIT add .
	Write-Host "END!"
})
$x_left                                         = 0
$y_top                                          = $y_top + $d_top

###COMMIT
$GETcommit                                      = New-Object system.Windows.Forms.Button
$GETcommit.text                                 = "GET::: Last Commit"
$GETcommit.width                                = $d_left-5
$GETcommit.height                               = $d_top-5
$GETcommit.location                             = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$GETcommit.Font                                 = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$Panel_default.Controls.Add($GETcommit)
$GETcommit.Add_Click({
	Write-Host "BEGIN::: GET commit!"
	$outVar = (git log -1) | Out-String
	$outShell = New-Object -ComObject Wscript.Shell
	$outShell.Popup($outVar,0,"Last Commit")
	Write-Host "END!"
})
$x_left                                         = $x_left + 200
$SETcommit                                      = New-Object system.Windows.Forms.Button
$SETcommit.text                                 = "SET::: Commit"
$SETcommit.width                                = $d_left-5
$SETcommit.height                               = $d_top-5
$SETcommit.location                             = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$SETcommit.Font                                 = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$Panel_default.Controls.Add($SETcommit)
$SETcommit.Add_Click({
	Write-Host "BEGIN::: SET commit!"
	$commit = Read-Host -Prompt 'commit = '
	& $GIT add .
	& $GIT commit -m $commit
	Write-Host "END!"
})
$x_left                                         = 0
$y_top                                          = $y_top + $d_top

###PUSH and PULL
$PushAndPull                                    = New-Object system.Windows.Forms.Button
$PushAndPull.text                               = "PushAndPull"
$PushAndPull.width                              = $d_left-5
$PushAndPull.height                             = $d_top-5
$PushAndPull.location                           = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$PushAndPull.Font                               = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$Panel_default.Controls.Add($PushAndPull)
$PushAndPull.Add_Click({
	Write-Host "BEGIN::: PushAndPull!"
	& $GIT push -u origin master
	Write-Host "END!"
})
$x_left                                         = 0
$y_top                                          = $y_top + $d_top

####################################################################################
###CLONE:
$gitlab_clone                                      = New-Object system.Windows.Forms.Button
$gitlab_clone.text                                 = "GITLAB ::: clone"
$gitlab_clone.width                                = $d_left-5
$gitlab_clone.height                               = $d_top-5
$gitlab_clone.location                             = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$gitlab_clone.Font                                 = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$Panel_default.Controls.Add($gitlab_clone)
$gitlab_clone.Add_Click({
	Write-Host "BEGIN::: git_clone!"
	& $GIT -c http.sslVerify=false clone $repoLinkGL
	Write-Host "END!"
})
$x_left                                         = $x_left + 200
###LASTVERSION
$LastVersion                                = New-Object system.Windows.Forms.Button
$LastVersion.text                           = "HARD ::: LastVersion"
$LastVersion.width                          = $d_left-5
$LastVersion.height                         = $d_top-5
$LastVersion.location                       = New-Object System.Drawing.Point(($x_left+$margin_left),($y_top+$margin_top))
$LastVersion.Font                           = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$LastVersion.Enabled                        = $True
$Panel_default.Controls.Add($LastVersion)
$LastVersion.Add_Click({
	Write-Host "BEGIN::: LastVersion!"
	& $GIT -c http.sslVerify=false fetch origin
	& $GIT reset --hard origin/master
	& $GIT clean -f -d
	Write-Host "END!"
})
$x_left                                         = 0
$y_top                                          = $y_top + $d_top

[void]$Form.ShowDialog()