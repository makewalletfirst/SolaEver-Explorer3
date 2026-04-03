# SolaEver-Explorer3 
<br>
도커허브에 커밋함. 파비콘, 로고 바꿈
<br>
이미지 수정 빌드 방법
<br>
cd ~/solaever-explorer

# 1. 깃허브 푸시
git add .
git commit -m "feat: update favicon and add missing dependencies"
git push

# 2. 도커 빌드
docker build --network=host -t silverruler/solaever-explorer:0.1.0 .

# 3. 도커허브 업로드
docker push silverruler/solaever-explorer:0.1.0

<br>
<br>

localhost -> dns : rpc-sola.ever-chain.xyz
