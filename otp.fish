function otp
    set -l default_key 'AWS'
	#set -l key_to_use (count $argv > 0 and echo $argv[1] or echo $default_key)
	set -l key_to_use (echo $default_key)
	echo "使用するキー: '$key_to_use'"
	set -l secret ''

    switch $key_to_use
        case 'AWS'
            set secret 'YOUR_BASE32_SECRET_FOR_SERVICE1'
        case 'service2'
            set secret 'YOUR_BASE32_SECRET_FOR_SERVICE2'
        case 'github'
            set secret 'YOUR_GITHUB_BASE32_SECRET'
        case '*'
            echo "Error: OTP secret for '$key_to_use' not found." >&2
            return 1
    end

    # 3. GENERATE AND DISPLAY THE OTP
    # This part runs the command and copies the result to the clipboard.
    if not set -l generated_otp (oathtool --totp --digits=6 --time-step-size=30s --base32 $secret)
        echo "Error: oathtool failed for key '$key_to_use'." >&2
        return 1
    end

    echo "Key: $key_to_use"
    echo "OTP: $generated_otp"

	# macOSでは pbcopy を使ってクリップボードにコピーする
	if command -v pbcopy >/dev/null 2>&1
   		 echo -n $generated_otp | pbcopy
    	echo "✅ Copied to clipboard."
	end
end
