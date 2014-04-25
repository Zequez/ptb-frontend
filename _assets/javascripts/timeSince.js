function timeSince(date) {
    var seconds = Math.floor((new Date() - date) / 1000);

    var interval = seconds / 31536000;
    var s = function(val) { return val === 1 ? '' : 's' };
    if (interval > 1) {
        return Math.round(interval * 10)/10 + " year" + s(interval);
    }
    interval = Math.floor(seconds / 2592000);
    if (interval >= 1) {
        return interval + " month" + s(interval);
    }
    interval = Math.floor(seconds / 86400);
    if (interval >= 1) {
        return interval + " day" + s(interval);
    }
    interval = Math.floor(seconds / 3600);
    if (interval >= 1) {
        return interval + " hour" + s(interval);
    }
    interval = Math.floor(seconds / 60);
    if (interval >= 1) {
        return interval + " minute" + s(interval);
    }

    return Math.floor(seconds) + " second" + s(seconds);
}