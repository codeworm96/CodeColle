describe("list.js", function () {
    it("should implement head", function () {
        var a = [1, 2, 3];
        var result = a.head();
        expect(a).toEqual([1, 2, 3]);
        expect(result).toBe(1);
    });

    it("should implement tail", function () {
        var a = [1, 2, 3];
        var result = a.tail();
        expect(a).toEqual([1, 2, 3]);
        expect(result).toEqual([2, 3]);
    });

    it("should implement init", function () {
        var a = [1, 2, 3];
        var result = a.init();
        expect(a).toEqual([1, 2, 3]);
        expect(result).toEqual([1, 2]);
    });

    it("should implement last", function () {
        var a = [1, 2, 3];
        var result = a.last();
        expect(a).toEqual([1, 2, 3]);
        expect(result).toBe(3);
    });

    it("should implement foldl", function () {
        var a = [1, 2, 3];
        var res = foldl(function (a, b) { return a + b; }, 0, a);
        expect(a).toEqual([1, 2, 3]);
        expect(res).toBe(6);
    });

    it("should implement foldr", function () {
        var a = [1, 2, 3];
        var res = foldr(function (a, b) { return a * b; }, 1, a);
        expect(a).toEqual([1, 2, 3]);
        expect(res).toBe(6);
    });

    it("should implement foldl1", function () {
        var a = [1, 2, 3];
        var res = foldl1(function (a, b) { return a + b; }, a);
        expect(a).toEqual([1, 2, 3]);
        expect(res).toBe(6);
    });

    it("should implement foldr1", function () {
        var a = [1, 2, 3];
        var res = foldr1(function (a, b) { return a * b; }, a);
        expect(a).toEqual([1, 2, 3]);
        expect(res).toBe(6);
    });

    it("should implement scanl", function () {
        var a = [1, 2, 3];
        var res = scanl(function (a, b) { return a + b}, 0, a);
        expect(a).toEqual([1, 2, 3]);
        expect(res).toEqual([0, 1, 3, 6]);
    });
});
