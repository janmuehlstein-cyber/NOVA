const CACHE='nova-pulse-v1-2';
const ASSETS=['./','./index.html','./styles.css','./app.js','./manifest.webmanifest','./icon.svg'];
self.addEventListener('install',event=>event.waitUntil((async()=>{const cache=await caches.open(CACHE);await cache.addAll(ASSETS);await self.skipWaiting()})()));
self.addEventListener('activate',event=>event.waitUntil((async()=>{const keys=await caches.keys();await Promise.all(keys.filter(key=>key!==CACHE).map(key=>caches.delete(key)));await self.clients.claim()})()));
self.addEventListener('fetch',event=>{
  if(event.request.method!=='GET')return;
  const url=new URL(event.request.url);
  const isAppShell=['.html','.js','.css'].some(ext=>url.pathname.endsWith(ext))||url.pathname.endsWith('/');
  if(isAppShell){
    event.respondWith((async()=>{try{const fresh=await fetch(event.request,{cache:'no-store'});if(fresh.ok){const cache=await caches.open(CACHE);cache.put(event.request,fresh.clone())}return fresh}catch{const cached=await caches.match(event.request);return cached||caches.match('./index.html')}})());
    return;
  }
  event.respondWith(caches.match(event.request).then(cached=>cached||fetch(event.request).then(response=>{if(response.ok){const copy=response.clone();caches.open(CACHE).then(cache=>cache.put(event.request,copy))}return response})));
});
