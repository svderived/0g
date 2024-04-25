sudo systemctl daemon-reload
sudo systemctl enable ogd
sudo systemctl restart ogd
sudo journalctl -u ogd -f -o cat
