/**
 * 属性订阅器
 */
class Dep {
  /**
   *
   * @returns {Array.<Watcher>}
   */
  get subs() {
    return this._subs;
  }
  get id() {
    return this._id;
  }

  constructor() {
    this._id = Dep.uid++;
    this._subs = [];
  }

  /**
   *
   * @param { Watcher }sub
   */
  addSub(sub) {
    this.subs.push(sub);
  }

  depend() {
    Dep.target.addDep(this);
  }

  removeSub(sub) {
    const index = this.subs.indexOf(sub);
    if (index !== -1) {
      this.subs.splice(index, 1);
    }
  }

  notify() {
    this.subs.forEach((sub) => {
      sub.update();
    });
  }
}


Dep.uid = 0;
Dep.target = null;
export default Dep;