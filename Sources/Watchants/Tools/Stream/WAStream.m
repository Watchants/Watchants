//
//  WAStream.m
//  Watchants iOS
//
//  Created by Panghu on 4/8/20.
//

#import "WAStream.h"

#import <sys/stat.h>
#import <sys/mman.h>
#import <sys/errno.h>

#import <Watchants/WALog.h>
#import <Watchants/WATypes.h>

struct _WAStream {
    int fd;
    char *path;
    void *mem;
    size_t mem_size;
    size_t mem_advance;
};

static inline int _capacity_expansion(struct _WAStream * stream, size_t buffer_len) {
    int result = 0;
    int fd = stream->fd;
    void *mem = stream->mem;
    size_t mem_size = stream->mem_size;
    size_t mem_advance = stream->mem_advance;

    if (mem_size >= mem_advance + buffer_len)
        return result;

    stream->mem = NULL;
    stream->mem_size = 0;
    result = munmap(mem, mem_size);
    if (result != 0) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    mem = NULL;
    mem_size = mem_size < 1 * 1024 * 1024 ? mem_size * 2 : mem_size + 4096 * 10;
    result = ftruncate(fd, mem_size);
    if (result != 0) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    mem = mmap(NULL, mem_size, PROT_WRITE, MAP_SHARED, fd, 0);
    if (mem == NULL) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    if (mem == (void*)-1) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    goto success;

success:
    stream->mem = mem;
    stream->mem_size = mem_size;
    return _capacity_expansion(stream, buffer_len);

failure:
    return result;
}

WAStreamRef _Nullable WAStreamOpen(const char * filepath) {
    int fd = -1;
    void *mem = NULL;
    size_t mem_size = 4096;
    size_t mem_advance = 0;
    struct _WAStream * stream = NULL;

    if (filepath == NULL)
        goto failure;

    fd = open(filepath, O_RDWR | O_CREAT, S_IRWXU);
    if (fd <= 0) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    struct stat st;
    if (fstat(fd, &st) != 0) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    if (st.st_size < mem_size && ftruncate(fd, mem_size) != 0) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    mem = mmap(NULL, mem_size, PROT_WRITE, MAP_SHARED, fd, mem_advance);
    if (mem == NULL) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    if (mem == (void*)-1) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        goto failure;
    }

    goto success;

success:
    stream = (struct _WAStream *)malloc(sizeof(struct _WAStream));
    stream->fd = fd;
    stream->path = strdup(filepath);
    stream->mem = mem;
    stream->mem_size = mem_size;
    stream->mem_advance = mem_advance;
    return stream;

failure:
    return NULL;
}

void WAStreamClose(WAStreamRef this_stream) {
    if (this_stream == NULL)
        return;

    int result = 0;
    int fd = this_stream->fd;
    char *path = this_stream->path;
    void *mem = this_stream->mem;
    size_t mem_size = this_stream->mem_size;
    struct _WAStream *stream = (struct _WAStream *)this_stream;

    if (mem != NULL) {
        result = munmap(mem, mem_size);
        if (result != 0) {
            WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        }
    }

    if (fd >= 0) {
        result = close(fd);
        if (result != 0) {
            WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        }
    }

    if (path != NULL) {
        free(path);
    }

    stream->fd = -1;
    stream->path = NULL;
    stream->mem = NULL;
    stream->mem_size = 0;

    free(stream);
}

int WAStreamWrite(WAStreamRef this_stream, const uint8_t * buffer, size_t len) {
    if (this_stream == NULL)
        return -1;
    if (buffer == NULL)
        return -1;
    if (len <= 0)
        return -1;

    int result = 0;
    struct _WAStream *stream = (struct _WAStream *)this_stream;
    result = _capacity_expansion(stream, len);
    if (result != 0)
        return result;

    void *at_address = stream->mem + stream->mem_advance;
    if (memcpy(at_address, buffer, len) != at_address) {
        WALogSymbol(WALEVEL_ERROR, __FILE__, __LINE__, __func__, strerror(errno));
        return -1;
    }

    stream->mem_advance += len;
    return result;
}
