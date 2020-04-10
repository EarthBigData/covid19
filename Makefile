object = ebd_covid19.ipynb
all:
	cd /s/notebooks/covid19
	# ./Build_US_TimeSeries.py
	# wget -O /s/data/covid19/time_series_19-covid-Confirmed.csv https://www.soothsawyer.com/wp-content/uploads/2020/03/time_series_19-covid-Confirmed.csv
	# wget -O /s/data/covid19/time_series_19-covid-Deaths.csv https://www.soothsawyer.com/wp-content/uploads/2020/03/time_series_19-covid-Deaths.csv
	jupyter nbconvert --execute $(object) --to html --no-input --output-dir /s/notebooks/covid19/html
	git pull
	git add .
	git commit -m "Automatic update"
	git push
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index.html

nb2html:
	cd /s/notebooks/covid19
	/s/anaconda/envs/seppo/bin/jupyter nbconvert --execute $(object) --to html --no-input --output-dir /s/notebooks/covid19/html
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index.html

dev:
	cd /s/notebooks/covid19
	/s/anaconda/envs/seppo/bin/jupyter nbconvert --execute $(object) --to html --no-input --output-dir /s/notebooks/covid19/html
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index2.html

upload:
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index.html

clear:
	jupyter nbconvert --clear-output $(object)


