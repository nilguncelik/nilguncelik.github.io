git add --all
git commit -m "."
git push
mkdir temp
mv ../nilguncelik.github.io/.git temp
rm -rf ../nilguncelik.github.io
mkdir ../nilguncelik.github.io
mv temp/.git ../nilguncelik.github.io
rm -rf temp
rsync -av --exclude='.git' --exclude='_site' . ../nilguncelik.github.io
cd ../nilguncelik.github.io
find ./_posts -type f -exec grep -L "public: true" {} \; | xargs rm
git add --all
git commit -m "."
git push
cd ../blog
