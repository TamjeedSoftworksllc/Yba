local https = game:GetService("HttpService")

local colors = {
	red = 16711680,
	green = 65280,
	blue = 255,
	black = 0,
	yellow = 16514837,
}

local function exploitRequest(url, method, body)
	local reqFunc = nil
	if syn and syn.request then
		reqFunc = syn.request
	elseif http and http.request then
		reqFunc = http.request
	elseif request then
		reqFunc = request
	end

	if reqFunc then
		local success, response = pcall(function()
			return reqFunc({
				Url = url,
				Method = method or "POST",
				Body = body,
				Headers = {
					["Content-Type"] = "application/json"
				}
			})
		end)
		if success then
			return response
		else
			error("Request failed: "..tostring(response))
		end
	else
		error("No exploit HTTP request function found!")
	end
end

local function postWebhook(url, data)
	local finalUrl = string.gsub(url, "discord.com", "webhook.lewisakura.moe")
	local finalBackupUrl = string.gsub(url, "discord.com", "webhook.newstargeted.com")

	local success, err = pcall(function()
		exploitRequest(finalUrl, "POST", data)
	end)

	if not success then
		warn("Error: "..tostring(err).." Trying backup URL")
		local backupSuccess, backupErr = pcall(function()
			exploitRequest(finalBackupUrl, "POST", data)
		end)
		if backupSuccess then
			print("Backup request success")
		else
			warn("Backup request failed "..tostring(backupErr).." bad request or both proxy down")
		end
	end
end

local function sendMessage(url, messageData)
	local data = {
		content = messageData.Content or ""
	}
	local finalData = https:JSONEncode(data)
	postWebhook(url, finalData)
end

local function sendAuthorEmbed(url, embedData)
	local data = {
		content = embedData.Content or "",
		embeds = {{
			author = {
				name = embedData.Author or "",
				icon_url = embedData.AuthorUrl or "",
				url = embedData.AuthorLink or "",
			},
			description = embedData.Description or "",
			color = embedData.Color or colors.black,
			fields = embedData.Fields,
			image = { url = embedData.Image or "" },
			thumbnail = { url = embedData.Thumbnail or "" },
			timestamp = embedData.TimeStamp or "",
			footer = {
				text = embedData.Footer or "",
				icon_url = embedData.FooterIcon or "",
			}
		}},
	}
	local finalData = https:JSONEncode(data)
	postWebhook(url, finalData)
end

local function sendEmbed(url, embedData)
	local data = {
		content = embedData.Content or "",
		embeds = {{
			image = { url = embedData.Image or "" },
			thumbnail = { url = embedData.Thumbnail or "" },
			title = "**"..(embedData.Title or "No Title Provided").."**",
			description = embedData.Description or "",
			type = "rich",
			color = embedData.Color or colors.black,
			fields = embedData.Fields,
			timestamp = embedData.TimeStamp or "",
			footer = {
				text = embedData.Footer or "",
				icon_url = embedData.FooterIcon or "",
			},
		}},
	}
	local finalData = https:JSONEncode(data)
	postWebhook(url, finalData)
end

return {
	colors = colors,
	sendMessage = sendMessage,
	sendAuthorEmbed = sendAuthorEmbed,
	sendEmbed = sendEmbed,
}
