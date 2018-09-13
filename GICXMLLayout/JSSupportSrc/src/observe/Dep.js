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
    if (Dep.target) {
      Dep.target.addDep(this);
    }
  }

  removeSub(sub) {
    const index = this.subs.indexOf(sub);
    if (index !== -1) {
      this.subs.splice(index, 1);
    }
  }

  notify() {
    const subs = this.subs.slice();
    for (let i = 0, l = subs.length; i < l; i++) {
      subs[i].update();
    }
  }
}


Dep.uid = 0;
Dep.target = null;
export default Dep;