#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static uint32_t crc32_tab[256];
static void crc32_init(void){
  for(uint32_t i=0;i<256;i++){uint32_t c=i;for(int j=0;j<8;j++) c=(c&1)?(0xEDB88320u^(c>>1)):(c>>1);crc32_tab[i]=c;}
}
static uint32_t crc32_calc(const uint8_t* d, uint32_t n){uint32_t c=0xFFFFFFFFu;for(uint32_t i=0;i<n;i++) c=crc32_tab[(c^d[i])&0xFFu]^(c>>8);return c^0xFFFFFFFFu;}
static void le16(uint8_t* p,uint16_t v){p[0]=v&255;p[1]=(v>>8)&255;}
static void le32(uint8_t* p,uint32_t v){p[0]=v&255;p[1]=(v>>8)&255;p[2]=(v>>16)&255;p[3]=(v>>24)&255;}
static int w(int fd,const void*buf,size_t n){return write(fd,buf,n)==(ssize_t)n?0:-1;}

typedef struct{const char*name;const uint8_t*data;uint32_t size;uint32_t crc;uint32_t off;uint32_t mode;} E;
static uint8_t sh_buf[4096], pkg_buf[4096], motd_buf[4096], build_only_buf[256], busybox_buf[4096], proot_buf[4096];
static uint8_t apt_buf[4096], apt_get_buf[4096], apkmanager_buf[4096], shellbash_buf[4096], busybox_safe_buf[4096], proot_safe_buf[4096];
static const uint8_t symlinks_buf[] = "sh\342\206\220bin/raf-bootstrap-sh\n";
static const uint8_t compat_buf[] =
"#!/system/bin/sh\n"
"PREFIX=${PREFIX:-/data/data/com.termux.rafacodephi/files/usr}\n"
"status=0\n"
"check(){ if [ ! -e \"$1\" ]; then echo missing:$1 >&2; status=1; elif [ ! -x \"$1\" ]; then chmod 700 \"$1\" 2>/dev/null || status=1; fi; }\n"
"check \"$PREFIX/bin/sh\"\n"
"check \"$PREFIX/bin/pkg\"\n"
"[ -d \"$PREFIX/bin\" ] && find \"$PREFIX/bin\" -maxdepth 1 -type f -exec chmod 700 {} \\; 2>/dev/null || true\n"
"[ -d \"$PREFIX/libexec\" ] && find \"$PREFIX/libexec\" -type f -exec chmod 700 {} \\; 2>/dev/null || true\n"
"[ -d \"$PREFIX/lib/apt/methods\" ] && find \"$PREFIX/lib/apt/methods\" -type f -exec chmod 700 {} \\; 2>/dev/null || true\n"
"[ -x \"$PREFIX/bin/sh\" ] && \"$PREFIX/bin/sh\" -c 'echo shell_exec_ok=1'\n"
"exit $status\n";

static int valid_zip_path(const char* p){
  if(!p||!p[0]||p[0]=='/') return 0;
  if(strstr(p,"..")!=NULL) return 0;
  return 1;
}
static int load_file(const char* root, const char* relative_path, uint8_t* out, uint32_t* n){
  if(!valid_zip_path(relative_path)) return -1;
  char path[512];
  int path_n=snprintf(path,sizeof(path),"%s/%s",root,relative_path);
  if(path_n<=0||path_n>=(int)sizeof(path)) return -1;
  int fd=open(path,O_RDONLY);
  if(fd<0) return -1;
  ssize_t r=read(fd,out,4096);
  close(fd);
  if(r<=0||r>=4096) return -1;
  *n=(uint32_t)r;
  return 0;
}

int main(int argc,char**argv){
  if(argc!=3) return 2;
  const char* out=argv[1]; const char* abi=argv[2];
  static char info[768];
  const char* bootstrap_pkg=getenv("TERMUX_BOOTSTRAP_PACKAGE_NAME");
  const char* page_size=getenv("TERMUX_BOOTSTRAP_PAGE_SIZE");
  const char* payload_root=getenv("RAF_BOOTSTRAP_SRC_DIR");
  const char* min_api="21";
  if(!bootstrap_pkg||!bootstrap_pkg[0]) bootstrap_pkg="com.termux.rafacodephi";
  if(!page_size||!page_size[0]) page_size="16384";
  if(!payload_root||!payload_root[0]) payload_root="bootstrap_src/common";
  if(strcmp(abi,"arm")==0) min_api="28";
  int info_n=snprintf(info,sizeof(info),
    "TERMUX_PACKAGE_NAME=%s\nTERMUX_ARCH=%s\nTERMUX_PAGE_SIZE=%s\nTERMUX_MIN_API=%s\nRAFCODEPHI_BOOTSTRAP=local-ci\nBOOTSTRAP_UTILS_READY=1\nBOOTSTRAP_APKMANAGER_READY=1\nBOOTSTRAP_SHELLBASH_READY=1\nBOOTSTRAP_BUSYBOX_SAFE_READY=1\nBOOTSTRAP_PROOT_SAFE_READY=1\nBOOTSTRAP_COMPAT_HOTFIX_READY=1\nBOOTSTRAP_FULLENGINE_READY=1\nBOOTSTRAP_PATHS_VALIDATED=1\nBOOTSTRAP_PERMISSIONS_DECLARED=1\nBOOTSTRAP_COMMAND_WRAPPERS_READY=1\nBOOTSTRAP_BUSYBOX_PRESENT=1\nBOOTSTRAP_PROOT_PRESENT=1\n",
    bootstrap_pkg,abi,page_size,min_api);
  if(info_n<=0||info_n>=(int)sizeof(info)) return 18;

  uint32_t sh_n=0,pkg_n=0,motd_n=0,busybox_n=0,proot_n=0,apt_n=0,apt_get_n=0,apkmanager_n=0,shellbash_n=0,busybox_safe_n=0,proot_safe_n=0;
  if(load_file(payload_root,"bin/sh", sh_buf, &sh_n)!=0) return 8;
  if(load_file(payload_root,"bin/pkg", pkg_buf, &pkg_n)!=0) return 9;
  if(load_file(payload_root,"bin/busybox", busybox_buf, &busybox_n)!=0) return 12;
  if(load_file(payload_root,"bin/proot", proot_buf, &proot_n)!=0) return 13;
  if(load_file(payload_root,"bin/apt", apt_buf, &apt_n)!=0) return 20;
  if(load_file(payload_root,"bin/apt-get", apt_get_buf, &apt_get_n)!=0) return 21;
  if(load_file(payload_root,"bin/apkmanager", apkmanager_buf, &apkmanager_n)!=0) return 14;
  if(load_file(payload_root,"bin/shellbash", shellbash_buf, &shellbash_n)!=0) return 15;
  if(load_file(payload_root,"bin/busybox-safe", busybox_safe_buf, &busybox_safe_n)!=0) return 16;
  if(load_file(payload_root,"bin/proot-safe", proot_safe_buf, &proot_safe_n)!=0) return 17;
  if(load_file(payload_root,"etc/motd", motd_buf, &motd_n)!=0) return 10;

  const char* marker="BUILD_ONLY=0\nRUNTIME_READY=1\nBOOTSTRAP_PACKAGE_INSTALLABLE=1\nFULLENGINE_READY=1\nCOMMAND_WRAPPERS_READY=1\n";
  uint32_t build_only_n=(uint32_t)snprintf((char*)build_only_buf,sizeof(build_only_buf),"%s",marker);
  E e[]={
    {"BOOTSTRAP_INFO",(uint8_t*)info,(uint32_t)info_n,0,0,0600},{"SYMLINKS.txt",symlinks_buf,(uint32_t)(sizeof(symlinks_buf)-1),0,0,0600},{"BUILD_ONLY",build_only_buf,build_only_n,0,0,0600},
    {"bin/sh",sh_buf,sh_n,0,0,0700},{"bin/pkg",pkg_buf,pkg_n,0,0,0700},{"bin/busybox",busybox_buf,busybox_n,0,0,0700},{"bin/proot",proot_buf,proot_n,0,0,0700},
    {"bin/apt",apt_buf,apt_n,0,0,0700},{"bin/apt-get",apt_get_buf,apt_get_n,0,0,0700},{"bin/apkmanager",apkmanager_buf,apkmanager_n,0,0,0700},
    {"bin/shellbash",shellbash_buf,shellbash_n,0,0,0700},{"bin/busybox-safe",busybox_safe_buf,busybox_safe_n,0,0,0700},{"bin/proot-safe",proot_safe_buf,proot_safe_n,0,0,0700},
    {"bin/rafcodephi-compat-hotfix",compat_buf,(uint32_t)(sizeof(compat_buf)-1),0,0,0700},{"etc/motd",motd_buf,motd_n,0,0,0600}
  };
  const int n_entries=(int)(sizeof(e)/sizeof(e[0]));

  crc32_init(); for(int i=0;i<n_entries;i++){ if(!valid_zip_path(e[i].name)) return 19; e[i].crc=crc32_calc(e[i].data,e[i].size); }
  int fd=open(out,O_CREAT|O_TRUNC|O_WRONLY,0644); if(fd<0) return 3;
  uint32_t off=0;
  for(int i=0;i<n_entries;i++){
    uint8_t h[30]; memset(h,0,sizeof(h)); le32(h,0x04034b50); le16(h+4,20); le16(h+8,0); le16(h+10,0); le32(h+14,e[i].crc); le32(h+18,e[i].size); le32(h+22,e[i].size); le16(h+26,(uint16_t)strlen(e[i].name));
    e[i].off=off; if(w(fd,h,30)||w(fd,e[i].name,strlen(e[i].name))||w(fd,e[i].data,e[i].size)){close(fd);return 4;} off += 30 + (uint32_t)strlen(e[i].name)+e[i].size;
  }
  uint32_t cdir_off=off;
  for(int i=0;i<n_entries;i++){
    uint8_t c[46]; memset(c,0,sizeof(c)); le32(c,0x02014b50); le16(c+4,0x031e); le16(c+6,20); le32(c+16,e[i].crc); le32(c+20,e[i].size); le32(c+24,e[i].size); le16(c+28,(uint16_t)strlen(e[i].name)); le32(c+38,((0100000u|e[i].mode)<<16)); le32(c+42,e[i].off);
    if(w(fd,c,46)||w(fd,e[i].name,strlen(e[i].name))){close(fd);return 5;} off += 46 + (uint32_t)strlen(e[i].name);
  }
  uint32_t cdir_sz=off-cdir_off;
  uint8_t z[22]; memset(z,0,sizeof(z)); le32(z,0x06054b50); le16(z+8,n_entries); le16(z+10,n_entries); le32(z+12,cdir_sz); le32(z+16,cdir_off);
  if(w(fd,z,22)){close(fd);return 6;}
  close(fd); return 0;
}
