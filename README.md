1) Run docker container docker run -itd --name gpdb dzolotov/gpdb
2) Go to container shell (docker exec -it gpdb bash)
3) Start sshd server (sudo /sbin/sshd)
4) Check ssh with keyauth (ssh localhost)
5) Configure path (source /usr/local/gpdb/greenplum_path.sh)
6) run: make create-demo-cluster
7) run: source gpAux/gpdemo/gpdemo-env.sh
8) create db: createdb -h localhost -p gpdb
9) connect to DB: psql

