function Send-Email {
	param(
		[string]$toAddress = "JYe@xxx.xxx", 
		[string]$fromAddress = "Default",
		[string]$subject = "Automated Email", 
		[string]$attachment = "Default", 
		[string]$emailbody = "Default"
		)

	#set basic parameters
	$smtpServer = "smtprelay.xxx.xxx"
	$defaultDomain = "xxx.xxx"
	$msg = new-object Net.Mail.MailMessage
	$smtp = new-object Net.Mail.SmtpClient($smtpServer)

	#apply the from address
	if($fromAddress -eq "Default"){
		$fromAddress = "{0}@{1}" -f $env:computername, $defaultDomain
	}
	$msg.From = $fromAddress

	#apply each to address
	foreach($address in $toAddress -split ",") {
		$msg.To.Add($address)
	}
	$msg.Subject = $subject

	#check if the attachment is valid
	if (($attachment -ne "Default") -and (Test-Path $attachment)){
		$att = new-object Net.Mail.Attachment($attachment)
		$msg.Attachments.Add($att)
		#update the body text
		if($emailbody -eq "Default"){
			$emailbody = "Attached is the file {0}" -f $attachment
		}
		$msg.Body = $emailbody 
		$smtp.Send($msg)
		$att.Dispose()
	} else {
		#update the body text
		if($emailbody -eq "Default"){
			$emailbody = "Automated email: no body specified by sender"
		}
		$msg.Body = $emailbody
		$smtp.Send($msg)
	}
}

$DbvistProcessNumber = (Get-Process | where {$_.ProcessName -eq "dbvrep"}).Length

if ($DbvistProcessNumber -ne 4) {
	Send-Email "JYe@xxx.xxx" "Default" "Alert - One or more of the Dbvisit processes have stopped" "Default" "OMG! Human intervention is required!"
}