cd $pwd
1..10 | % { write "" }

echo "Create Pay for link publishing transaction"

$publisher_day_price = Read-Host "enter publisher price per day for placing backlink, found in publisher tx "
$publisher_wallet_address = Read-Host "enter publisher wallet address ex(MJbvkR6oUS1rBh2abf8grm6F9X7yv3Y3Jr) found in publisher tx "
$advertiser_page_link = Read-Host "enter advertiser back link ex(boating.info)"

$data_string = [System.String]::Concat("adv:",$advertiser_page_link)
echo $data_string

while($data_string.length -gt 79)
{
    echo $data_string
    echo ($data_string.length -gt 79)
    write-host "data string is above 80 char max size, reduce url length"
    $advertiser_page_link = Read-Host "enter advertiser back link ex(boating.info)"

    $data_string = [System.String]::Concat("adv:",$advertiser_page_link)

}


$days_to_publish = Read-Host "enter days to keep link published"
$tx_vout = Read-Host "enter transaction id to spend from ex(81a11f6801c661f0e601e13c33caf6c71a86f90a06594bf7680a7b51d04e5527)"
$tx_vout_count = Read-Host "enter spend from transaction id vout number ex(0)"

$total_to_pay = [decimal]$days_to_publish * [decimal]$publisher_day_price

echo "hex encoded data for transaction"

$char_array = $data_string.ToCharArray();
$hex_data = ""
Foreach ($element in $char_array) 
{
    $hx = [System.String]::Format("{0:x}", [System.Convert]::ToUInt32($element))
    $hex_data+=$hx
    
}

write-host $hex_data
$cmd_a = "`"[{`\`"txid`\`":`\`"$tx_vout`\`",`\`"vout`\`":$tx_vout_count}]`"" 
$cmd_b = "`"[{`\`"$publisher_wallet_address`\`":$total_to_pay}, {`\`"data`\`":`\`"$hex_data`\`"}]`""
write-host $cmd_a
write-host $cmd_b

$raw_tx = (.\litecoin-cli.exe -datadir=dataV212 createrawtransaction  $cmd_a $cmd_b )

write-host "raw transaction " $raw_tx

write-host "sign transcation in wallet using hex output string"
write-host "send transcation from wallet"



