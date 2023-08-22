#block 2527953
#blockhash
#f213221f32892e0a64c3ee375a3e4969ab319b46bf6f727d0beae0479daaf38b
#txid 311b4f3af0c810feab057f6d066650585b11c02fd31d992ad4770cee250f6a42 publisher data found 6461795f70726963653a73756d6d6572626c6f672e77733a302e303032
#day_price:summerblog.ws:0.002

cd $pwd
1..10 | % { write "" }

echo "block 2527953"
$blockhash = (.\litecoin-cli.exe -datadir=dataV212 getblockhash 2527953)

echo "blockhash" $blockhash

$tx_list = (.\litecoin-cli.exe -datadir=dataV212 getblock $blockhash)

$tx_json=($tx_list | ConvertFrom-Json)

for ($tx_id=0;  $tx_id -lt $tx_json.tx.length; $tx_id++) {
    $raw_tx=(.\litecoin-cli.exe -datadir=dataV212 getrawtransaction $tx_json.tx[$tx_id])
    $progress = $tx_id / ($tx_json.tx.length/100)
    Write-Progress  $tx_json.tx[$tx_id] $progress
    

    $tx=(.\litecoin-cli.exe -datadir=dataV212 decoderawtransaction $raw_tx)
    $tx_op_json=($tx | ConvertFrom-Json)
    $op_data = $tx_op_json.vout[1].scriptPubKey.asm
    if ($op_data -like "OP_RETURN*") 
    { 
        $op_data = $op_data.Replace('OP_RETURN ', '')

        $op_text = -join ($op_data -split '(..)' | ? { $_ } | % { [char][convert]::ToUInt32($_,16) })
        if ($op_text -like "day_price*") 
        {
            write-host "txid" $tx_json.tx[$tx_id] "publisher data found" $op_data
            write-host $op_text
        }
    }
}



