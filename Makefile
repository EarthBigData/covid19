object = ebd_covid19.ipynb
all:
	cd /s/notebooks/covid19
	jupyter nbconvert --execute $(object) --to html --no-input --output-dir /s/notebooks/covid19/html
	git pull
	git add .
	git commit -m "Automatic update"
	git push
